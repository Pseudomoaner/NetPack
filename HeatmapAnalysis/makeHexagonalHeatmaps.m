% See the makingHeatmaps.txt file for more info on how to prepare files for
% this code. Essentially bins the 'triangular' heatmaps to create more
% regularized versions of the same.

clear all
close all

root = 'D:\Ravinash network analysis\Prints_V4\Prints_21_03_18\ZZ033B\';

branches = {'average_Hex_Reg_Stacks.tif';'average_Amo_Reg_Stacks.tif';'average_Squ_Reg_Stacks.tif';'average_Nop_Reg_Stacks.tif'};

template = 'FittedTemplateSkeleton.tif';

%Read in image data
imagePlanes = [];
for i = 1:size(branches,1)
    imagePlanes = cat(3,imagePlanes,imread([root,branches{i}]));
end

%Read in location data
templateImg = imread([root,template]);
labelledVer = bwlabel(templateImg,4);
hexBins = zeros(max(labelledVer(:)),1);
amoBins = zeros(max(labelledVer(:)),1);
squBins = zeros(max(labelledVer(:)),1);
nopBins = zeros(max(labelledVer(:)),1);

hexPlane = imagePlanes(:,:,1);
amoPlane = imagePlanes(:,:,2);
squPlane = imagePlanes(:,:,3);
nopPlane = imagePlanes(:,:,4);

for i = 1:max(labelledVer(:))
    currPxs = find(labelledVer == i);
    hexBins(i) = sum(hexPlane(currPxs));
    amoBins(i) = sum(amoPlane(currPxs));
    squBins(i) = sum(squPlane(currPxs));
    nopBins(i) = sum(nopPlane(currPxs));
end

hexProps = hexBins./(hexBins + amoBins + squBins + nopBins);
amoProps = amoBins./(hexBins + amoBins + squBins + nopBins);
squProps = squBins./(hexBins + amoBins + squBins + nopBins);
nopProps = nopBins./(hexBins + amoBins + squBins + nopBins);

%For each face in the network skeleton, create a patch with the pixels as
%x,y positions and colour it according to the amount of hexagonal packing
%occuring in that face
figure(1)
ax1 = axes('Position',[0.025,0.55,0.45,0.4],'Units','normalized');
ax2 = axes('Position',[0.525,0.55,0.45,0.4],'Units','normalized');
ax3 = axes('Position',[0.025,0.05,0.45,0.4],'Units','normalized');
ax4 = axes('Position',[0.525,0.05,0.45,0.4],'Units','normalized');

fullChan = [0:0.025:1,ones(size(0.025:0.025:1))]';
emptyChan = [zeros(size(0:0.025:1)),0.025:0.025:1]';
CmapHex = [fullChan,fullChan,emptyChan];
CmapSqu = [fullChan,emptyChan,emptyChan];
CmapAmo = [emptyChan,fullChan,fullChan];
CmapNop = [emptyChan,emptyChan,fullChan];

maxC = 1; %Maximum color value for maps to be normalised against

for i = 2:max(labelledVer(:)) %From 2, to ignore the bounding box (the surround)
     currPxs = labelledVer == i;
     boundLocs = find(bwperim(currPxs));
     [boundY,boundX] = ind2sub(size(templateImg),boundLocs);
     ordBound = bwtraceboundary(currPxs,[boundY(1),boundX(1)],'w');
     ordBound(:,1) = smooth(ordBound(:,1));
     ordBound(:,2) = smooth(ordBound(:,2));
     
     %Hexagonal packing first
     faceVal = round((hexProps(i)/maxC)*size(CmapHex,1));
     faceCol = CmapHex(faceVal,:);
     
     patch(ax1,ordBound(:,2),ordBound(:,1),faceCol,'LineWidth',2,'EdgeColor','k')
     
     %Then square
     faceVal = round((squProps(i)/maxC)*size(CmapSqu,1)) + 1;
     faceCol = CmapSqu(faceVal,:);
     
     patch(ax2,ordBound(:,2),ordBound(:,1),faceCol,'LineWidth',2,'EdgeColor','k')
     
     %Then amorphous
     faceVal = round((amoProps(i)/maxC)*size(CmapAmo,1)) + 1;
     faceCol = CmapAmo(faceVal,:);
     
     patch(ax3,ordBound(:,2),ordBound(:,1),faceCol,'LineWidth',2,'EdgeColor','k')
     
     %Then no-pack
     faceVal = round((nopProps(i)/maxC)*size(CmapNop,1)) + 1;
     faceCol = CmapNop(faceVal,:);
     
     patch(ax4,ordBound(:,2),ordBound(:,1),faceCol,'LineWidth',2,'EdgeColor','k')
     
     colormap(ax4,CmapNop);
     c4 = colorbar(ax4);
end
axis(ax1,'equal')
axis(ax1,'tight')
axis(ax1,'off')
ax1.YDir = 'reverse';
ax1.Box = 'off';
ax1.XTick = [];
ax1.YTick = [];

colormap(ax1,CmapHex);
c1 = colorbar(ax1);
c1.LineWidth = 2;
c1.FontSize = 15;

axis(ax2,'equal')
axis(ax2,'tight')
axis(ax2,'off')
ax2.YDir = 'reverse';
ax2.Box = 'off';
ax2.XTick = [];
ax2.YTick = [];     

colormap(ax2,CmapSqu);
c2 = colorbar(ax2);
c2.LineWidth = 2;
c2.FontSize = 15;

axis(ax3,'equal')
axis(ax3,'tight')
axis(ax3,'off')
ax3.YDir = 'reverse';
ax3.Box = 'off';
ax3.XTick = [];
ax3.YTick = [];

colormap(ax3,CmapAmo);
c3 = colorbar(ax3);
c3.LineWidth = 2;
c3.FontSize = 15;

axis(ax4,'equal')
axis(ax4,'tight')
axis(ax4,'off')
ax4.YDir = 'reverse';
ax4.Box = 'off';
ax4.XTick = [];
ax4.YTick = [];

colormap(ax4,CmapNop);
c4 = colorbar(ax4);
c4.LineWidth = 2;
c4.FontSize = 15;