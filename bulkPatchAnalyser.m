clear all
close all

%Choose superdirectory
root = 'D:\Ravinash network analysis\Prints_V4\Control\';

%Find names of subdirectories
conts = dir(root);
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

leafSet = {'_filled_nopack.png';'_filled_amo.png';'_filled_hex.png';'_filled_squ.png'};

for i = 1:size(branches,1)
    close all
    
    fullRoot = [root,branches{i},filesep];
    conts = dir(fullRoot);
    goodInds = [];
    for j = 1:size(conts,1)
        if ~isempty(regexp(conts(j).name,'net..tif', 'once'))
            goodInds = [goodInds;j];
        end
    end
    twigs = cell(size(goodInds,1),1);
    for j = 1:size(goodInds,1)
        twigs{j} = conts(goodInds(j)).name(1:4);
    end
    [patchAreas,patchPerimeters] = measurePatches(fullRoot,twigs,leafSet);

    save([root,branches{i},filesep,'patchProperties.mat'],'patchAreas','patchPerimeters')
end