################
##  Task 4 - Morphometric Demonstrations
##  Byron Smith
##  9/9/2020
##
##  This code is written to explore different morphological operations and
##  how they may apply to specific images.  These operations are kinds of
##  filters that take the maximum or minimum within a window (sometimes both).
##  The reason to use these operations is to clean pixel-by-pixel annotations
##  prior to processing or after model predictions.


library(jpeg)
library(EBImage)


# Read in the image -------------------------------------------------------

##  Pull in the image
pic1 <- readJPEG("~/preprocessing/AT2Scan.jpg")

# Create the image --------------------------------------------------------

mask2 <- ifelse(pic1[,,3] < 0.8 | pic1[,,2] < 0.8, 1, 0)
cols <- rainbow(3, alpha=0.3)[2] # Initialize the green color used in mask demonstrations

# First, an dilation with hull filling:
mask3 <- dilate(mask2, makeBrush(21, shape="disc"))
mask3 <- fillHull(mask3)
mask3 <- ifelse(mask3==1, cols, "#00000000")

# Next, an erosion with hull filling:
mask4 <- erode(mask2, makeBrush(21, shape="disc"))
mask4 <- fillHull(mask4)
mask4 <- ifelse(mask4==1, cols, "#00000000")

# Followed by an opening (dilation, then erosion)
mask5 <- opening(mask2, makeBrush(21, shape="disc"))
mask5 <- fillHull(mask5)
mask5 <- ifelse(mask5==1, cols, "#00000000")

# Finally, the difference between a dilation and a closing.
mask6 <- dilate(mask2, makeBrush(21, shape="disc"))
mask6 <- fillHull(mask6)
mask7 <- closing(mask2, makeBrush(21, shape="disc"))
mask7 <- fillHull(mask7)
mask7 <- ifelse(mask7==1, cols,
                ifelse(mask6==1, "#FF0000FF", "#00000000"))

jpeg("MorphDemos.jpg", width=dim(pic1)[2]*2, height=dim(pic1)[1]*2, units="px")

par(mar=c(0, 0, 0, 0), mfrow=c(2,2))

# Dilation
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask3, 1, 1, 2, 2)

# Erosion
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask4, 1, 1, 2, 2)

# Opening
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask5, 1, 1, 2, 2)

# Dilation and Closing
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask7, 1, 1, 2, 2)

dev.off()


