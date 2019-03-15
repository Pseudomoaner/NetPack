function [] = plotTriMeshAreas(tri,x,y,c,sz,class)
%Works much the same as trisurf or trimesh, but colours each face according to a number associated with that face (rather than the edge)

f = figure(2);
cla
f.Visible = 'on';
f.Position = [0,0,1024,1024];
ax = gca;
ax.Position = [0,0,1,1];
ax.XTick = [];
ax.YTick = [];
ax.Color = 'k';
ax.YDir = 'reverse';

colormap('gray')

for i = 1:size(tri,1)
    ptX = x(tri(i,:));
    ptY = y(tri(i,:));
    
    if c(i) == class    
        p = patch(ptX,ptY,'w','EdgeColor','none');
    end
end

axis([0,sz(1),0,sz(2)])