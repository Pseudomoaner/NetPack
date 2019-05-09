# NetPack
Network packing analysis. For further details, please see 'Packing of droplets in 3D-printed networks for synthetic tissues', Alessandro Alcinesio, Oliver J. Meacock, Rebecca G. Allan, Carina Monico, Ravinash Krishna Kumar and Hagan Bayley.

This pipeline is only semi-automated, so requires some degree of user input. Some stages will require you to use Fiji/imageJ - download here: https://fiji.sc/#download

We begin with z-stack images of droplet networks. The first stage is to select the single 2D plane from each 3D image with with the cleanest droplet boundaries in the first layer. For example:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net.png" alt="Raw network"/>
</p>

Each network has been printed under different conditions, with a variable number of repeats performed within a single condition. Each condition will be assocated with a tag 'expX' and each repeat with a tag 'repX'. All images should be square and the same dimensions (number of pixels in the x and y-directions).

Save each plane using the format 'RootDir/expX/repX'. For maximum compatibility with pre-existing formatting, ensure the 'expX' string is of the format 'ZZ%i%i%i%w', where %i represents a single digit and %w a single letter. Also ensure that the 'repX' string is of the format 'net_%i', where %i increases from 1 to the total number of repeats in that condition (assumed less than 10).

## To create network outlines

Step 1: Run createRoughNetworkSegmentation.m on each directory 'RootDir/expX' to do rough ridge detection.

Step 2: Manually adjust resulting network in Fiji to remove any small breaks between droplets (using the original image as an overlay and the brush tool). This step also acts as the quality control stage.

This generates an outline of the droplets:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_Network_Corrected.png" alt="Outline network"/>
</p>

## To perform network analysis

Step 1: Run bulkNetworkAnalyser.m. One of the outcomes of this script is an image of the triange classification, overlayed on top of the original network:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_Overlay.png" alt="Network overlay"/>
</p>

You can use this to adjust the classification parameters to match your problem (Classification parameters are found in classifyDropMesh.m).

Step 2: Run bulkNetworkDrawer.m. This generates a binary image of the regions packing under a given regime. For example, here are the hexagonally packed regions of our example network:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_hex.png" alt="Network hexagonal regions"/>
</p>

Step 3: To measure the properties of these packing type patches (perimeters, areas etc.), run bulkPatchAnalyser.m.

Step 4: You should now see that 'RootDir/expX/networkProperties.mat' and 'RootDir/expX/patchProperties.mat' exist in each expX folder. To export to Excel, run WritePackingDataToExcel.m.

## To generate heatmaps

Step 1: For a single folder RootDir/expX, manually register each network repX to a 'perfect' reference network in Fiji using transparent overlays and Plugins -> Transform -> Interactive rigid. Save as repX_Reg.tif - you should now have an initial repX.tif image as well as a registered repX_Reg.tif image for each network.

For reference, here is the reference network for our example print:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_Template.png" alt="Network template"/>
</p>

Step 2: Do usual network segmentation and correction stages (i.e. repeat 'create network outlines' steps on repX_Reg).

Step 3: Run 'bulkNetworkDrawer.m'.

Step 4: For each packing type, load all resulting binary mesh images into Fiji, concatenate all repeats into a single stack, then run Image -> Stacks -> Z Project (average). Across all repeats for this experimental condition, for example, this generated the following image:

<p align="center">
  <img src="https://raw.githubusercontent.com/Pseudomoaner/NetPack/master/ExampleImages/net_hexAvg.jpg" alt="Network hexagonal average"/>
</p>

Step 5: Run 'makeHexagonalHeatmaps.m' to create the final normalised heatmaps. Note that you will also need to provide a skeletonised version of the reference network for this to work.
