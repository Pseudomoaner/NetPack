close all
clear all

Root = 'C:\Users\olijm\Desktop\PackingLast\ZZ033B\';
baseImgNos = [1];

for i = 1:size(baseImgNos,2)
    baseImg = [Root,'net',num2str(baseImgNos(i))];
    inImg = [baseImg,'.tif'];
    outImg = [baseImg,'_Network.tif'];
    
    ridgeRange = 15;
    ridgeThresh = 0.1;
    
    %Read the input
    tmp = imread(inImg);
    img = double(tmp(:,:,1));
    
    %Create a rough segmentation of the image based on ridge detection. This will be improved manually later.
    ridgeImg = bwRidgeCenterMod(255-img,ridgeRange,ridgeThresh);
    
    imwrite(ridgeImg,outImg,'Compression','none');
end