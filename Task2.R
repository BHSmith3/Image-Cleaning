################
##  Task 2 - Tile Sampling
##  Byron Smith
##  9/9/2020
##
##  This code is written to inspect tissue sampling.  Deep learning
##  algorithms are not generally built to run on large images and may need
##  to be sub-sampled.  Here we look at 2 different systematic sampling
##  methods as well as a random sampling method.  Almost always deep
##  learning input are squares of size 256x256, 512x512, etc. and so
##  I follow suite by demonstrating these sampling methods using
##  squares of 240x240.

##  One reason to inspect an image like this is to explore what kind
##  of information may be captured in a sub-sampling and then processed
##  by a model.



library(jpeg)
library(EBImage)

set.seed(48735739)

# Read in the image -------------------------------------------------------

##  Pull in the image
pic1 <- readJPEG("~/preprocessing/AT2Scan.jpg")


# Tile demonstrations -----------------------------------------------------

# Start with a disjoint grid.
disjoint.grid.x <- seq(258, 1698, by=240)/dim(pic1)[2]+1
disjoint.grid.y <- seq(24, 2184, by=240)/dim(pic1)[1]+1

# Next, an overlapping grid
# 1440 = 2, 2, 2, 2, 2, 3, 3, 5
# try out a sequence by 160 instead of 240.

overlapping.grid.x <- seq(258, 1698, by=288)/dim(pic1)[2]+1
overlapping.grid.y <- seq(24, 2184, by=288)/dim(pic1)[1]+1

##  Random sampling

num.boxes <- 54 # Same size as the disjoint grid
dim.box <- 240/dim(pic1)[1:2]


jpeg("AllTiled.jpg", width=dim(pic1)[2]*3, height=dim(pic1)[1], units="px")

# Exclusive grid
par(mar=c(0, 0, 0, 0), mfrow=c(1,3))
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
for(i in 1:length(disjoint.grid.x)){
  lines(rep(disjoint.grid.x[i], 2), c(24, 2184)/dim(pic1)[1]+1, lwd=2)
}
for(i in 1:length(disjoint.grid.y)){
  lines(c(258, 1698)/dim(pic1)[2]+1, rep(disjoint.grid.y[i], 2), lwd=2)
}

# Overlapping Grid
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
for(i in 1:length(overlapping.grid.x)){
  lines(rep(overlapping.grid.x[i], 2), c(24, 2160)/dim(pic1)[1]+1, lwd=2)
  lines(rep(overlapping.grid.x[i], 2)+80/dim(pic1)[2], c(24, 2160)/dim(pic1)[1]+1, lwd=2)
}
for(i in 1:length(overlapping.grid.y)){
  lines(c(258, 1698)/dim(pic1)[2]+1, rep(overlapping.grid.y[i], 2), lwd=2)
  lines(c(258, 1698)/dim(pic1)[2]+1, rep(overlapping.grid.y[i], 2)+80/dim(pic1)[1], lwd=2)
}

# Random tiles
plot(1:2, type='n', xlab='', ylab='', xaxt='n', yaxt='n', main="", bty='n')
rasterImage(pic1, 1, 1, 2, 2)
for(i in 1:num.boxes){
  temp.pos <- c(sample(258:1458, 1), sample(24:1944, 1))/dim(pic1)[1:2]+1
  
  rect(temp.pos[1], temp.pos[2], temp.pos[1]+dim.box[1], temp.pos[2]+dim.box[2], lwd=2)
}


dev.off()

