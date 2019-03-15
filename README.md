# NetPack
Network packing analysis

This pipeline is semi-automated, so requires some degree of user input.

Some stages require Fiji/imageJ - download here: https://fiji.sc/#download

FOR NETWORK PROPERTY ANALYSIS



FOR HEATMAP GENERATION
Step 1: Manually register images in Fiji using transparent overlays and Plugins -> Transform -> Interactive rigid. Save as netX_Reg.tif

Step 2: Do usual network segmentation and correction stages

Step 3: Run 'bulkNetworkDrawer.m'. Make sure to change the line 'if c(i) == n' to the appropriate class (0 = no pack, 1 = amorphous,
 2 = square, 3 = hexagonal). Also make sure to change the line 'export_fig([root,stem{St},'_XXX.png'],'-png')' in drawPackingTypes to 
point to a new image file in each case. 

Step 4: Load all resulting mesh images into Fiji, concatenate into a single stack, then run Image -> Stacks -> Z Project (average)

Step 5: Run 'makeHeatmaps.m' to create the final normalised heatmaps.
