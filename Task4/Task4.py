################
##  Task 4 - Morphological Demonstrations
##  Byron Smith
##  9/9/2020
##
##  This code is written to explore different morphological operations and
##  how they may apply to specific images.  These operations are kinds of
##  filters that take the maximum or minimum within a window (sometimes both).
##  The reason to use these operations is to clean pixel-by-pixel annotations
##  prior to processing or after model predictions.

import numpy as np
import cv2
from matplotlib import pyplot as plt

def fillHull(img):
    c2, _ = cv2.findContours(img, cv2.RETR_EXTERNAL,
                             cv2.CHAIN_APPROX_SIMPLE)  # RETR_EXTERNAL means only use external contours.
    for i in range(len(c2)):
        cv2.drawContours(img, c2, i, 255, -1)  # Not all hulls got filled!!

    return img


######################
##  Read in the image
######################

pic1 = cv2.imread("~/AT2Scan.jpg")

# The default read of a JPEG image using cv2 is in blue-green-red rather than red-green-blue.
# I will convert this for consistency.
pic1 = cv2.cvtColor(pic1, cv2.COLOR_BGR2RGB)

####################
##  Morphological Demonstrations
#######################

pic2 = cv2.cvtColor(pic2, cv2.COLOR_RGB2GRAY)
mask1 = cv2.threshold(pic2, 200, 255, cv2.THRESH_BINARY_INV)[1]

kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (21, 21))

mask2 = cv2.dilate(mask1, kernel, iterations=1)
mask2 = fillHull(mask2)

mask3 = cv2.erode(mask1, kernel, iterations=1)
mask3 = fillHull(mask3)

mask4 = cv2.morphologyEx(mask1, cv2.MORPH_OPEN, kernel)
mask4 = fillHull(mask4)

mask5 = cv2.dilate(mask1, kernel, iterations=1)
mask5 = fillHull(mask5)
mask5 = cv2.morphologyEx(mask5, cv2.MORPH_CLOSE, kernel)
mask5 = fillHull(mask5)

mask6 = mask2 - mask5