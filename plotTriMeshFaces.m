function [] = plotTriMeshFaces(tri,x,y,c,cmapName,label)
%Works much the same as trisurf or trimesh, but colours each face according to a number associated with that face (rather than the edge)

f = figure(2);
f.Position = [0,0,1024,1024];
ax = gca;
ax.Position = [0,0,1,1];

cmap = colormap(cmapName);
colormap('gray')

for i = 1:size(tri,1)
    ptX = x(tri(i,:));
    ptY = y(tri(i,:));
   
    faceColourInd = floor(((c(i))*(size(cmap,1)-1))/3) + 1;
    faceColour = cmap(faceColourInd,:);
    
    p = patch(ptX,ptY,faceColour,'LineWidth',1);
    p.FaceAlpha = 0.5;
    
    if label
        text(mean(ptX),mean(ptY),num2str(i));
    end
end