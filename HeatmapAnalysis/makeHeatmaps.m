% See the makingHeatmaps.txt file for more info on how to prepare files for
% this code. Essentially bins the 'triangular' heatmaps to create more
% regularized versions of the same.

clear all
close all

root = 'D:\Ravinash network analysis\Prints_21_03_18\ZZ033B\';

branches = {'average_Hex_Reg_Stacks_Crop.tif';'average_Amo_Reg_Stacks_Crop.tif';'average_Squ_Reg_Stacks_Crop.tif';'average_Nop_Reg_Stacks_Crop.tif'};

nX = 10; %Number of bins in the x-direction
nY = 10;

imagePlanes = [];
for i = 1:size(branches,1)
    imagePlanes = cat(3,imagePlanes,imread([root,branches{i}]));
end

[szY,szX,nP] = size(imagePlanes);

binEdgesX = round(0:szX/nX:szX);
binEdgesY = round(0:szY/nY:szY);

pxTots = zeros(nX,nY,nP);

for x = 1:nX
    for y = 1:nY
        for p = 1:nP
            pxTots(x,y,p) = sum(sum(imagePlanes(binEdgesY(y)+1:binEdgesY(y+1),binEdgesY(x)+1:binEdgesY(x+1),p)));
        end
    end
end

normFacs = sum(pxTots,3);
colours = {'y','c','r','b'};

figure(1)
for i = 1:2
    for j = 1:2
        subplot(2,2,j + (i-1)*2)
        imagesc((pxTots(:,:,j + (i-1)*2)./normFacs)')
        caxis([0,1]);
        colormap('hot')
        ax = gca;
        axis tight
        axis equal
        ax.LineWidth = 5;
        ax.XTick = [];
        ax.YTick = [];
        ax.YColor = colours{j + (i-1)*2};
        ax.XColor = colours{j + (i-1)*2};
    end
end

hp4 = get(subplot(2,2,4),'Position');
cb = colorbar('Position', [hp4(1)+hp4(3)+0.01  hp4(2)  0.03  hp4(2)+hp4(3)*2.1]);
cb.LineWidth = 2;