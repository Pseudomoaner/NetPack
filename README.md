# NetPack
Network packing analysis

This pipeline is semi-automated, so requires some degree of user input.

Some stages require Fiji/imageJ - download here: https://fiji.sc/#download

We begin with an image of a droplet network, for example:



TO CREATE NETWORK OUTLINES
Step 1: Select single basal plane of network in Fiji. Turn 8-bit and do 1 pixel wide Gaussian filtering.

Step 2: Run createRoughNetworkSegmentation.m on this image to do rough ridge detection.

Step 3: Adjust resulting network manually in Fiji (useing the original image as an overlay).



TO 
3: Repeat for all data, then run findTriangleClusters.m to decide on the boudaries for your morphological classes - adjust these within classifyDropMesh.m

4: Run measurePackingProportions.m for all networks. Feel free to adjust the four drop parameters
 (dropAreaLowerLim, dropAreaUpperLim, dropThresh and dropProportion) so as to accurately differentiate drops and oil inclusions (based on size and intensity)
 
5: Proportions of packing types are output as text strings 

TO GENERATE HEATMAPS
Step 1: Manually register images in Fiji using transparent overlays and Plugins -> Transform -> Interactive rigid. Save as netX_Reg.tif

Step 2: Do usual network segmentation and correction stages

Step 3: Run 'bulkNetworkDrawer.m'. Make sure to change the line 'if c(i) == n' to the appropriate class (0 = no pack, 1 = amorphous,
 2 = square, 3 = hexagonal). Also make sure to change the line 'export_fig([root,stem{St},'_XXX.png'],'-png')' in drawPackingTypes to 
point to a new image file in each case. 

Step 4: Load all resulting mesh images into Fiji, concatenate into a single stack, then run Image -> Stacks -> Z Project (average)

Step 5: Run 'makeHeatmaps.m' to create the final normalised heatmaps.
