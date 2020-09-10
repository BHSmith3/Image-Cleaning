################
##  Task 3 - Prediction Cleaning
##  Byron Smith
##  9/9/2020
##
##  This code is written to clean up the output of a pixel-by-pixel
##  classification model also known as segmentation.  One major issue
##  is that predictions will often have spurious and errant pixel predictions
##  as well as gaps in the predictions.
##  We then take the raw and fixed predictions and compare them to a tile-wise
##  prediction.


library(jpeg)
library(png)
library(EBImage)


# Read in the image -------------------------------------------------------

pic1 <- readJPEG("~/preprocessing/AT2Scan.jpg")

# Read in the prediction --------------------------------------------------

mask1 <- readPNG("~/preprocessing/FakePred2.png")

# Check that the image size and prediction size are the same.
dim(pic1)
dim(mask1)

# Prediction Cleaning -----------------------------------------------------

cols <- rainbow(3, alpha=0.3)[2] # Initialize the green color used in mask demonstrations
pred <- ifelse(mask1, cols, "#00000000")

fixed.pred <- fillHull(mask1)
fixed.pred <- bwlabel(fixed.pred)
temp.rm <- names(which(table(fixed.pred)<2000))
fixed.pred <- rmObjects(fixed.pred, temp.rm)

fixed.pred2 <- ifelse(fixed.pred, cols, "#00000000")

squares.x <- c(4, 4, 4, 5, 4, 5)-1
squares.y <- c(2, 3, 6, 6, 7, 7)-1

mask2 <- matrix("#00000000", dim(pic1)[1], dim(pic1)[2])

for(i in 1:length(squares.x)){
  mask2[(squares.y[i]*240+24):(squares.y[i]*240+240+24), (squares.x[i]*240+258):(squares.x[i]*240 + 240 + 258)] <- cols
}

disjoint.grid.x <- seq(258, 1698, by=240)/dim(pic1)[2]+1
disjoint.grid.y <- seq(24, 2184, by=240)/dim(pic1)[1]+1

# Compare Images ----------------------------------------------------------

jpeg("Predictions.jpg", width=dim(pic2)[2]*3, height=dim(pic2)[1], units="px")

par(mar=c(0, 0, 0, 0), mfrow=c(1,3))

plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(pred, 1, 1, 2, 2)

plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(fixed.pred2, 1, 1, 2, 2)

plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
rasterImage(mask2, 1, 1, 2, 2)
for(i in 1:length(disjoint.grid.x)){
  lines(rep(disjoint.grid.x[i], 2), c(24, 2184)/dim(pic1)[1]+1, lwd=2)
}
for(i in 1:length(disjoint.grid.y)){
  lines(c(258, 1698)/dim(pic1)[2]+1, rep(disjoint.grid.y[i], 2), lwd=2)
}


dev.off()



