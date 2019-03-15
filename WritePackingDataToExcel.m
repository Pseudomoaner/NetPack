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

outFile = [root,'packingData.xlsx'];

rowRoot = 'Network ';

for i = 1:size(branches,1) %For each experimental condition
    load([root,branches{i},filesep,'networkProperties.mat']);
    load([root,branches{i},filesep,'patchProperties.mat']);
    
    %Write the packing proportions
    xlswrite(outFile,packStore,i,'B2')
    xlswrite(outFile,packNos,i,['B',num2str(size(packStore,1)*2 + 6)])
    xlswrite(outFile,patchAreas,i,['G',num2str(size(packStore,1)*2 + 6)])
    xlswrite(outFile,patchPerimeters,i,['L',num2str(size(packStore,1)*2 + 6)])
    xlswrite(outFile,{branches{i}},i,'A1')
    
    %Write the inclusion and external perimeters
    xlswrite(outFile,outPerimStore,i,['B',num2str(size(packStore,1) + 4)])
    xlswrite(outFile,incPerimStore,i,['C',num2str(size(packStore,1) + 4)])
    
    tableRows = {};
    for j = 1:size(packStore,1) %For each repeat of the experiment in this condition
        tableRows = [tableRows;[rowRoot,num2str(j)]];
        
        if ~isempty(oilAreaStore{j})
            xlswrite(outFile,oilAreaStore{j}',i,['H',num2str(j+1)])
        end
        
        if ~isempty(dropAreaStore{j})
            xlswrite(outFile,dropAreaStore{j}',i,['H',num2str(j+3+size(packStore,1))])
        end
%         %Collate contact angle data
%         doubleContactAng = []; %Get all the contact angles in this network
%         for k = 1:size(nodeMeasures{j},2) %Per node
%             if strcmp(nodeMeasures{j}(k).class,'ExtEdge') %If the node is at the droplet-exterior interface
%                 if sum(~isnan(nodeMeasures{j}(k).angDiffs)) == 3 && numel(nodeMeasures{j}(k).angDiffs) == 3 %If there are exactly three angles and they have been accurately measured
%                     if sum(numel(find(cellfun(@(x) strcmp(x,'ded'),nodeMeasures{j}(k).angClasses)))) == 1 && sum(numel(find(cellfun(@(x) strcmp(x,'edd'),nodeMeasures{j}(k).angClasses)))) == 2 %If the angle classes are correct
%                         doubleContactAng = [doubleContactAng;nodeMeasures{j}(k).angDiffs(find(cellfun(@(x) strcmp(x,'ded'),nodeMeasures{j}(k).angClasses)))];
%                     end
%                 end
%             end
%         end
%         
%         xlswrite(outFile,doubleContactAng',i,['H',num2str(j + 5 + 2*size(packStore,1))])
    end
    
    tableHeads = {'Hexagonal','Square','No-pack','Amorphous'};
    tableTriNoHeads = {'Hexagonal tri no','Square tri no','No-pack tri no','Amorphous tri no'};
    tablePatchArHeads = {'Hexagonal patch area','Square patch area','No-pack patch area','Amorphous patch area'};
    tablePatchPerimHeads = {'Hexagonal patch perim','Square patch perim','No-pack patch perim','Amorphous patch perim'};
    
    %Insert table headings for this condition
    xlswrite(outFile,tableHeads,i,'B1')
    xlswrite(outFile,tableRows,i,'A2')
    
    xlswrite(outFile,{'External perimeter (um)'},i,['B',num2str(size(packStore,1) + 3)])
    xlswrite(outFile,{'Inclusion perimeter (um)'},i,['C',num2str(size(packStore,1) + 3)])
    xlswrite(outFile,tableRows,i,['A',num2str(size(packStore,1) + 4)])
    
    xlswrite(outFile,{'Inclusion areas (um^2)'},i,'G1')
    xlswrite(outFile,tableRows,i,'G2')
    
    xlswrite(outFile,{'Droplet areas (um^2)'},i,['G',num2str(size(packStore,1)+3)])
    xlswrite(outFile,tableRows,i,['G',num2str(size(packStore,1)+4)])
    
    xlswrite(outFile,tableTriNoHeads,i,['B',num2str(size(packStore,1)*2 + 5)])
    xlswrite(outFile,tableRows,i,['A',num2str(size(packStore,1)*2 + 6)])
    
    xlswrite(outFile,tablePatchArHeads,i,['G',num2str(size(packStore,1)*2 + 5)])
    xlswrite(outFile,tablePatchPerimHeads,i,['L',num2str(size(packStore,1)*2 + 5)])
    
%     xlswrite(outFile,{'Double contact angles (degrees)'},i,['G',num2str(2*size(packStore,1)+5)])
%     xlswrite(outFile,tableRows,i,['G',num2str(2*size(packStore,1)+6)])
end