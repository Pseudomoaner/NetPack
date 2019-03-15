function stats = drawDropField(stats,dropBin,dropThresh,intersects,plotting)

zoneImg = zeros(size(dropBin,1),size(dropBin,2),3);

for i = 1:length(stats)
    currIDs = stats(i).PixelList;
    currOily = zeros(size(currIDs,1),1);
    for j = 1:size(currIDs,1)
        currOily(j) = dropBin(currIDs(j,2),currIDs(j,1));
    end
    if mean(currOily) > dropThresh
        for j = 1:size(currIDs,1)
            zoneImg(currIDs(j,2),currIDs(j,1),1) = 1;
        end
        stats(i).zone = 'Drop';
    else
        for j = 1:size(currIDs,1)
            zoneImg(currIDs(j,2),currIDs(j,1),2) = 1;
        end
        stats(i).zone = 'Oil';
    end
end

if plotting
    imshow(zoneImg)
    
    hold on
    
    for i = 1:size(intersects,1)
        plot(intersects(i,1),intersects(i,2),'w.','MarkerSize',12)
    end
end