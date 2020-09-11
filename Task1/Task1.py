################
##  Task 1 - Tissue identification
##  Byron Smith
##  9/10/2020
##
##  This code is written to identify tissue from a whole slide image.
##  First, we can immediately see that slide background is white and can
##  be identified as have red-green-blue values over 0.9 (or 240 on a 0-255 scale).
##  In order to choose the tissue, we want to choose all pixel values that don't
##  fit this criteria.

import numpy as np
import cv2
from matplotlib import pyplot as plt # Used to visualize the image intermittently if necessary.

def fillHull(img):
    # Create a hull filling function equivalent to R.

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

pic1.shape
# 2208, 2418, 3

###################
##  Identify tissue in the image
###################

# Set up a mask and overlay it.
mask = pic1.copy()
mask[:,:,0] = 0
mask[:,:,2] = 0
mask[:,:,1] = 255 * (pic1[:,:,2] < 230)

pic2 = pic1.copy()
cv2.addWeighted(mask, 0.3, pic2, 0.7, 0, dst=pic2)
plt.imshow(pic2)

mask2 = cv2.cvtColor(pic1, cv2.COLOR_RGB2GRAY)
mask2 = cv2.threshold(mask2, 200, 255, cv2.THRESH_BINARY_INV)[1]
mask2 = cv2.morphologyEx(mask2, cv2.MORPH_CLOSE, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (101,101)))

mask2 = fillHull(mask2)

##########################
##  Output the image
##########################

mask3 = np.zeros((pic1.shape), dtype='uint8')
mask3[:,:,1] = mask2

pic3 = pic1.copy()
cv2.addWeighted(mask3, 0.3, pic3, 0.7, 0, dst=pic3)

out, figs = plt.subplots(1,3)
figs[0].imshow(pic1)
figs[1].imshow(pic2)
figs[2].imshow(pic3)

# How do I output this now?
cv2.imwrite("Task1.jpg", figs)

