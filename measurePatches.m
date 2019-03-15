function [patchAreas,patchPerimeters] = measurePatches(root,twigs,leaves)
%Returns the area and preimeter measures of packing patches, in units of
%pixels.

patchAreas = zeros(size(twigs,1),size(leaves,1));
patchPerimeters = zeros(size(twigs,1),size(leaves,1));

for twig = 1:size(twigs,1)
    for leaf = 1:size(leaves,1)
        patchImg = imread([root,twigs{twig},leaves{leaf}]);
        labelledImg = bwlabeln(patchImg>254);
        
        area = 0;
        perim = 0;
        
        for seg = 1:max(labelledImg(:))
            onePatch = labelledImg == seg;
            stats = regionprops(onePatch,'Area','Perimeter');
            area = area + stats(1).Area;
            perim = perim + stats(1).Perimeter;
            
            %The below actually gives a fairly similar measure of perimeter
            %to the regionprops measurement, but is rather less stable.
            %Commented out for the time being.
            
%             %The 'jaggedness' of the pixel-based representation
%             %artificially inflates the apparent perimeter. To resolve,
%             %smoothing external trace data prior to measuring perimeter.
%             outer = bwperim(onePatch);
%             [outerX,outerY] = ind2sub(size(patchImg),find(outer));
%             perimList = bwtraceboundary(onePatch,[outerX(1),outerY(1)],'S',8,Inf);
%             if isempty(perimList)
%                 perimList = bwtraceboundary(onePatch,[outerX(1),outerY(1)],'N',8,Inf);
%             end
%             perimList(:,1) = circ_smooth(perimList(:,1),10);
%             perimList(:,2) = circ_smooth(perimList(:,2),10);
%             dPerim = diff(perimList,1);
%             dPerim = [dPerim;perimList(end,1)-perimList(1,1),perimList(end,2)-perimList(1,2)];
%            
%             perim = sum(sqrt(sum(dPerim.^2,2)));
        end
        patchAreas(twig,leaf) = area;
        patchPerimeters(twig,leaf) = perim;
    end
end