################
##  Task 1 - Tissue identification
##  Byron Smith
##  9/9/2020
##
##  This code is written to identify tissue from a whole slide image.
##  First, we can immediately see that slide background is white and can
##  be identified as have red-green-blue values over 0.9 (or 240 on a 0-255 scale).
##  In order to choose the tissue, we want to choose all pixel values that don't
##  fit this criteria.

library(jpeg)
library(EBImage)


# Read in the image -------------------------------------------------------

##  Pull in the image
pic1 <- readJPEG("~/preprocessing/AT2Scan.jpg")

##  Check out the size.
dim(pic1)
# 2208 2418 3

##  Check out one pixel of the background:
pic1[1,1,]


# Identify tissue in the image --------------------------------------------

cols <- rainbow(3, alpha=0.3)[2] # Initialize the green color used in mask demonstrations

##  Those that have a green and blue pixel colors < 0.9
mask1 <- ifelse(pic1[,,3] < 0.9 | pic1[,,2] < 0.9, cols, "#00000000")

## One thing that we can see is that this tissue has "hulls" in it.  That is,
## holes that show slide background despite being in the middle of the tissue.
## For downstream processing we may want to take the full 'chunk' of tissue
## and therefore choose the hulls along with the tissue.  To capture the hulls
## as well we use the fillHull() function.  Here I use the closing() function to
## smooth the mask out a little as well.

mask2 <- ifelse(pic1[,,3] < 0.9 | pic1[,,2] < 0.9, 1, 0)
mask2 <- closing(mask2, makeBrush(101, shape="disc"))
mask2 <- fillHull(mask2)
mask3 <- ifelse(mask2==1, cols, "#00000000")



# Output image ------------------------------------------------------------

##  Finally, we want to visualize what we have done.  Plotting the image in
## interactive R can take a long time so I will output the image.

jpeg(paste0(outdir, "Task1.jpg"), width=dim(pic1)[2]*3, height=dim(pic1)[1], units="px")

par(mar=c(0, 0, 0, 0), mfrow=c(1,3))

# Plot the raw image
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)

# Plot the image with tissue identified
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask1, 1, 1, 2, 2)

# Plot the image with tissue identified and hulls filled.
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask3, 1, 1, 2, 2)

dev.off()



