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

import numpy as np
import cv2
import random
from matplotlib import pyplot as plt
from matplotlib import patches as patches

######################
##  Read in the image
######################

pic1 = cv2.imread("~/AT2Scan.jpg")

# The default read of a JPEG image using cv2 is in blue-green-red rather than red-green-blue.
# I will convert this for consistency.
pic1 = cv2.cvtColor(pic1, cv2.COLOR_BGR2RGB)


############################
##  Grid Images
############################

out, figs = plt.subplots(1,3)
figs[0].imshow(pic1)
for i in range(258, 1699, 240):
    figs[0].plot([i,i], [24,2184], 'k-')
for i in range(24, 2185, 240):
    figs[0].plot([258,1698], [i,i], 'k-')

figs[1].imshow(pic1)
for i in range(258, 1699, 288):
    figs[1].plot([i, i], [24, 2184], 'k-')
    figs[1].plot([i+80, i+80], [24, 2184], 'k-')
for i in range(24, 2185, 288):
    figs[1].plot([258, 1698], [i, i], 'k-')
    figs[1].plot([258, 1698], [i+80, i+80], 'k-')

random.seed(48735739)
num_boxes = 54

figs[2].imshow(pic1)
for i in range(num_boxes):
    x = random.randrange(258, 1458)
    y = random.randrange(24, 1944)
    rect = patches.Rectangle([x,y], 240, 240, edgecolor='black', facecolor='none', fill=False)
    figs[2].add_patch(rect)


