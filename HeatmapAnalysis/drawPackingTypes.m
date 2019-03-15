function [] = drawPackingTypes(root,stem,rawStem,netStem)

dropAreaLowerLim = 0.4; %Proportion of median size of all drops for a drop to continue to be considered a drop.
dropAreaUpperLim = 10; %Proportion of median size of all drops for a drop to continue to be considered a drop.
dropThresh = 5;
dropProportion = 0.8; %Proportion of face that should be thresholded as a 'drop' to be recorded as a drop.
hullRatio = 0.9; %Minimum ratio of a face's area to its convex hull's area to be considered a drop.

dropAreaStore = cell(size(stem,1),1);
oilAreaStore = cell(size(stem,1),1);
netAreaStore = zeros(size(stem,1),1);
outPerimStore = zeros(size(stem,1),1);
incPerimStore = zeros(size(stem,1),1);

for St = 1:size(stem,1)
    %Read the inputs
    imgInfo = imfinfo([root,stem{St},rawStem]);
    img = double(imread([root,stem{St},rawStem]));
    dropImg = img > dropThresh;
    network = imread([root,stem{St},netStem]);
    pxSize = 1/imgInfo(1).XResolution;
    
    %Find filled network, get ratio of perimeter to area
    filledNet = imfill(network);
    outPerimedNet = bwperim(filledNet);
    
    netAreaStore(St) = sum(filledNet(:))*(pxSize^2);
    outPerimStore(St) = sum(outPerimedNet(:))*(pxSize);
    
    %Find network skeleton
    skeletonRidges = bwmorph(network,'skel',Inf);
    skeletonRidges = bwmorph(skeletonRidges,'shrink',Inf);
    skeletonRidges = bwmorph(skeletonRidges,'clean');
    
    %Collect statistics about the drop network
    drops = bwlabel(imclearborder(1-skeletonRidges,4),4);
    CC = bwconncomp(imclearborder(1-skeletonRidges,4),4);
    faces = regionprops(CC,'Area','PixelList','Centroid');
    
    faces = drawDropField(faces,dropImg,dropProportion,[],false);
    
    %Find the average drop size, and call any apparent drops that are too small to be so oil inclusions
    dropAreas = [];
    for i = 1:size(faces,1)
        if strcmp(faces(i).zone,'Drop')
            dropAreas = [dropAreas,faces(i).Area];
        end
        
        %Also extract the convex hull area of each face
        singleFace = drops == i;
        faceOutline = bwmorph(singleFace,'remove');
        [perimX,perimY] = ind2sub(size(img),find(faceOutline));
        
        if numel(perimX) >= 3 && sum(perimY == perimY(1)) ~= numel(perimY) && sum(perimX == perimX(1)) ~= numel(perimY) %Last two checks ensure points are not co-linear
            [~,faces(i).hullArea] = convhull(perimX,perimY);
        else
            faces(i).hullArea = Inf;
        end
    end
    dropArea = median(dropAreas);
    
    dropAreas = [];
    oilAreas = [];
    dropImg = zeros(size(network));
    for i = 1:size(faces,1)
        if faces(i).Area < dropArea * dropAreaLowerLim || faces(i).Area > dropArea * dropAreaUpperLim || (faces(i).Area/faces(i).hullArea) < hullRatio
            faces(i).zone = 'Oil';
        end
        
        if strcmp(faces(i).zone,'Oil')
            oilAreas = [oilAreas;faces(i).Area*pxSize^2];
        elseif strcmp(faces(i).zone,'Drop')
            dropAreas = [dropAreas;faces(i).Area*pxSize^2];
            for j = 1:size(faces(i).PixelList,1)
                dropImg(faces(i).PixelList(j,1),faces(i).PixelList(j,2)) = 1;
            end
        end
    end
    dropAreaStore{St} = dropAreas;
    oilAreaStore{St} = oilAreas;
    
    %Estimate inclusion perimeter
    dropImg = bwmorph(dropImg,'close',2);
    totPerimedNet = bwperim(dropImg);
    incPerimStore(St) = (sum(totPerimedNet(:)) - sum(outPerimedNet(:)))*(pxSize);
    
    %Create mesh of centroids of drops
    [tri,faceX,faceY] = createDropMesh(faces,500);
    
    %Measure and classify mesh
    [triAngs,triAreas,triLens] = measureDropMesh(tri,faceX,faceY);
    [triClass,~] = classifyDropMesh(triAngs,triAreas,triLens,false,dropArea);
    
    %Plot each triangle class separately
    plotTriMeshAreas(tri,faceX,faceY,triClass,size(img),0) %No-pack
    export_fig([root,stem{St},'_filled_nopack.png'],'-png')
    
    plotTriMeshAreas(tri,faceX,faceY,triClass,size(img),1) %Amorphous
    export_fig([root,stem{St},'_filled_amo.png'],'-png')
    
    plotTriMeshAreas(tri,faceX,faceY,triClass,size(img),2) %Hexagonal
    export_fig([root,stem{St},'_filled_hex.png'],'-png')
    
    plotTriMeshAreas(tri,faceX,faceY,triClass,size(img),3) %Square
    export_fig([root,stem{St},'_filled_squ.png'],'-png')
end