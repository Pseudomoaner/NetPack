%Should be run after all of the triangles have been compiled using bulkNetworkAnalyser.m
roots = {'D:\Ravinash network analysis\Prints_V4\Prints_Last_26_07_18\';'D:\Ravinash network analysis\Prints_V4\Prints_21_03_18\';'D:\Ravinash network analysis\Prints_V4\Prints_Extra_Last_09_09_18\'};

triAreaStore = [];
triLenStore = [];
triAngStore = [];
triClassStore = [];

for r = 1:size(roots,1)
    %Find names of subdirectories
    conts = dir(roots{r});
    goodInds = [];
    for j = 1:size(conts,1)
        if ~isempty(regexp(conts(j).name,'ZZ\d\d\d\w', 'once')) && numel(conts(j).name) == 6
            goodInds = [goodInds;j];
        end
    end
    branches = cell(size(goodInds,1),1);
    for j = 1:size(goodInds,1)
        branches{j} = conts(goodInds(j)).name;
    end
    
    for b = 1:size(branches,1)
        load([roots{r},branches{b},filesep,'networkProperties.mat']);
        
        triAreaStore = [triAreaStore;triAreas];
        triLenStore = [triLenStore;triLens];
        triAngStore = [triAngStore;triAngs];
        triClassStore = [triClassStore;triClass];
    end
end

triAngs = triAngStore(:,3);
triAreas = triAreaStore;
triPerims = triLenStore;

nXaa = 200;
nYaa = 1200;

nXap = 100;
nYap = 350;

Naa = hist3([triAreas,triAngs],'Nbins',[nYaa,nXaa]);
Nap = hist3([triPerims,triAngs],'Nbins',[nYap,nXap]);

xDiffaa = (max(triAngs) - min(triAngs))/nXaa;
yDiffaa = (max(triAreas) - min(triAreas))/nYaa;

xSetaa = linspace(min(triAngs)+xDiffaa/2,max(triAngs)-xDiffaa/2,nXaa);
ySetaa = linspace(min(triAreas)+yDiffaa/2,max(triAreas)-yDiffaa/2,nYaa);

xDiffap = (max(triAngs) - min(triAngs))/nXap;
yDiffap = (max(triPerims) - min(triPerims))/nYap;

xSetap = linspace(min(triAngs)+xDiffap/2,max(triAngs)-xDiffap/2,nXap);
ySetap = linspace(min(triPerims)+yDiffap/2,max(triPerims)-yDiffap/2,nYap);

f1 = figure(1);
f1.Units = 'normalized';
f1.Position = [0.2,0.2,0.3,0.35];
imagesc(xSetaa,ySetaa,Naa)
ax = gca;
ax.LineWidth = 2;
ax.YDir = 'normal';
ax.XTick = [];
ax.YTick = [];
colorbar
c = colorbar;
c.LineWidth = 2;
cmap = colormap('pink');
upsample = floor(max(Naa(:))./size(cmap,1));
cmapBig = [interp(cmap(:,1),upsample),interp(cmap(:,2),upsample),interp(cmap(:,3),upsample)];
cmapBig(cmapBig>1) = 1;
cmapBig(cmapBig<0) = 0;
cmapBig(1,:) = [1,1,1];
colormap(cmapBig)

%Plot sample triangle positions
hold on
plot(61.13,1.599,'o','MarkerSize',5,'MarkerEdgeColor',[1,0.5,0],'MarkerFaceColor','w','LineWidth',2)
plot(93.77,0.816,'o','MarkerSize',5,'MarkerEdgeColor',[0.5,0,1],'MarkerFaceColor','w','LineWidth',2)
plot(61.56,0.598,'o','MarkerSize',5,'MarkerEdgeColor','y','MarkerFaceColor','w','LineWidth',2)
plot(89.64,0.544,'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor','w','LineWidth',2)
plot(77.68,0.5227,'o','MarkerSize',5,'MarkerEdgeColor','c','MarkerFaceColor','w','LineWidth',2)
plot(146.97,0.79,'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor','w','LineWidth',2)

axis([60,180,0,1.75])

f2 = figure(2);
f2.Units = 'normalized';
f2.Position = [0.2,0.2,0.3,0.35];
imagesc(xSetap,ySetap,Nap)
ax = gca;
ax.LineWidth = 2;
ax.YDir = 'normal';
ax.XTick = [];
ax.YTick = [];
colorbar
c = colorbar;
c.LineWidth = 2;
colormap(cmapBig)

%Draw line for separating no-pack from pack regions:
class3Grad = 0.0545; %From idealised triangles (equilateral and icosoles right-angled)
class3Intercept = 3.73;
x = 60:180;
line(x,x*class3Grad + class3Intercept,'LineWidth',2,'LineStyle','--','Color','w')

%Plot sample triangle positions
hold on
plot(61.13,7.92,'o','MarkerSize',5,'MarkerEdgeColor',[1,0.5,0],'MarkerFaceColor','w','LineWidth',2)
plot(93.77,10.22,'o','MarkerSize',5,'MarkerEdgeColor',[0.5,0,1],'MarkerFaceColor','w','LineWidth',2)
plot(61.56,6.25,'o','MarkerSize',5,'MarkerEdgeColor','y','MarkerFaceColor','w','LineWidth',2)
plot(89.64,6.30,'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor','w','LineWidth',2)
plot(77.68,5.97,'o','MarkerSize',5,'MarkerEdgeColor','c','MarkerFaceColor','w','LineWidth',2)
plot(146.97,12.76,'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor','w','LineWidth',2)

axis([60,180,5,15])