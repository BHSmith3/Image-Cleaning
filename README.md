# Image-Cleaning
This repository is created to contain code that could be used to pre- and post-process histology images.  These demonstrations as well as additional information are contained within the manuscript "Developing Image Analysis Pipelines of Whole Slide Images: Pre- and Post-Processing" (http://doi.org/10.1017/cts/2020.531).

I have split the following code in to 4 'tasks' to demonstrate when and why you may want to use specific methods.

Task 1 - Tissue Identification:

  A researcher may want to separate tissue from slide background in order to feed images of the tissue in to deep learning or machine learning models.  Furthermore, morphometric measures (such as tissue size) can aid a researcher in establishing whether a biopsy is sufficiently large for diagnosis.
  This code will walk a new researcher through using a fixed threshold to separate tissue pixels from glass pixels, then apply a couple simple transformations to capture the full shape and size of the tissue without leaving gaps in the segmentation.
  

Task 2 - Tile Sampling:

  Modern deep learning algorithms are typically run on images that are of on the order of hundreds of pixels by hundreds of pixels.  However, whole slide images are typically gigapixel in size (tens of thousands by tens of thousands).  The solution is to create tiles or patches from the specific images and then feed these in to the deep learning algorithms.  A useful first step is oulined in Task 1 to isolate the tissue, then sample from it.  The bulk of whole slide images are actually glass slide background and are non-informative for further processing.
  This code will visualize three different sampling methods in order to allow a researcher a way to visually inspect how a larger image may be broken in to parts before processing.  This can help to identify balance in sampling (what proportion of samples may have regions of interest).


Task 3 - Prediction Cleaning:

  Image segmentation is a method whereby objects of interest are identified within an image.  One popular way to do this is to identify the specific pixels belonging to objects of interest.  This requires pixel-by-pixel predictions. Unfortunately, deep learning models often predict spurious and errant pixels as 'positive' as well as holes within objects of interest which reduce interpretability.
  This code will demonstrate what a typical prediction may look like and how to clean it up by using morphological operations as well as hull filling.  Furthermore, there is a contrast between pixel-wise prediction and tile-wise prediction.

Task 4 - Morphological Demonstrations:

  Many of the cleaning methods include using morphological operations (erosion, dilation, closing, opening, etc.) to combine pixels.  However, these are not always intuitive and it is important to understand the subtle differences that each method may provide.  Here we take a deep dive in to a few of the morphological operations and explore differences using a proper image.  Further exploration would be valuable for any researcher interested in the methods.
  
Notes about the code and images:
  It is important to note that the code included is a demonstration of the methods and under no circumstances are they memory or speed optimized.  I am simply interested in demonstrating the use of specific methods on histological images.  This code relies heavily on the 'EBImage' package in R (https://bioconductor.org/packages/release/bioc/html/EBImage.html) and the 'openCV' package in Python (https://pypi.org/project/opencv-python/).
  I also note that the images included are of kidney transplant biopsies with a focus on predicting large structures such as glomeruli.  This is in contrast to many, many applications of deep learning in image analysis focused on areas of cancer.  Nevertheless, the approaches should be similar and I have found that even a simpleton such as myself can identify a glomerulus on a kidney biopsy because it is a structure that stands out.
