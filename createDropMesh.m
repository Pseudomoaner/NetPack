function [tri,ptListX,ptListY] = createDropMesh(faces,areaThresh)

ptListX = [];
ptListY = [];

for i = 1:size(faces,1)
    if strcmp(faces(i).zone,'Drop') && faces(i).Area > areaThresh
        ptListX = [ptListX;faces(i).Centroid(1)];
        ptListY = [ptListY;faces(i).Centroid(2)];
    end
end

tri = delaunay(ptListX,ptListY);