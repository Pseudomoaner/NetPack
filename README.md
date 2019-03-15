# NetPack
Network packing analysis

This pipeline is only semi-automated, so requires some degree of user input. Some stages will require you to use Fiji/imageJ - download here: https://fiji.sc/#download

We begin with z-stack images of droplet networks. The first stage is to select the single 2D plane from each 3D image with with the cleanest droplet boundaries in the first layer. For example:

![Raw network](https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net.png)

Each network has been printed under different conditions, with a variable number of repeats performed within a single condition. Each condition will be assocated with a tag 'expX' and each repeat with a tag 'repX'.

Save each plane using the format 'RootDir/expX/repX'. For maximum compatibility with pre-existing formatting, ensure the 'expX' string is of the format 'ZZ%i%i%i%w', where %i represents a single digit and %w a single letter. Also ensure that the 'repX' string is of the format 'net_%i', where %i increases from 1 to the total number of repeats in that condition (assumed less than 10).

## To create network outlines

Step 1: Run createRoughNetworkSegmentation.m on each directory 'RootDir/expX' to do rough ridge detection.

Step 2: Manually adjust resulting network in Fiji to remove any small breaks between droplets (using the original image as an overlay and the brush tool). This step also acts as the quality control stage.

This generates an outline of the droplets:

![Outline network](https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_Network_Corrected.png)

## To perform network analysis

Step 1: Run bulkNetworkAnalyser.m. One of the outcomes of this script is an image of the triange classification, overlayed on top of the original network:

![Network overlay](https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_Overlay.png)

You can use this to adjust the classification parameters to match your problem (Classification parameters are found in classifyDropMesh.m).

Step 2: You should now see that 'RootDir/expX/networkProperties.mat' exists in each expX folder. To export to Excel, run WritePackingDataToExcel.m.

## To generate heatmaps

Step 1: Manually register images in Fiji using transparent overlays and Plugins -> Transform -> Interactive rigid. Save as netX_Reg.tif

Step 2: Do usual network segmentation and correction stages

Step 3: Run 'bulkNetworkDrawer.m'. Make sure to change the line 'if c(i) == n' to the appropriate class (0 = no pack, 1 = amorphous,
 2 = square, 3 = hexagonal). Also make sure to change the line 'export_fig([root,stem{St},'_XXX.png'],'-png')' in drawPackingTypes to 
point to a new image file in each case. 

This generates a binary image of the regions packing under a given regime. For example, here are the hexagonally packed regions of our example network:

![Network hexagonal regions](https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_hex.png)

Step 4: Load all resulting mesh images into Fiji, concatenate into a single stack, then run Image -> Stacks -> Z Project (average)

Step 5: Run 'makeHeatmaps.m' to create the final normalised heatmaps.
