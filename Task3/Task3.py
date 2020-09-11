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


import numpy as np
import cv2
from matplotlib import pyplot as plt

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

####################
##  Working with the prediction
####################

pred1 = cv2.imread("~/FakePred2.png", cv2.IMREAD_GRAYSCALE)
mask1 = np.zeros(pic1.shape, dtype='uint8')
mask1[:,:,1] = pred1
pic2 = cv2.addWeighted(mask1, 0.3, pic1, 1.0, 0.0)

c2, _ = cv2.findContours(pred1, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

mask2 = np.zeros(pic1.shape, dtype='uint8')
for i in range(len(c2)):
    if cv2.contourArea(c2[i]) < 2000:
        continue

    mask2 = cv2.drawContours(mask2, c2, i, 255, -1)

mask2 = mask2[:,:,[1,0,2]]
pic3 = cv2.addWeighted(mask2, 0.3, pic1, 1.0, 0.0)

squares_x = np.array([4, 4, 4, 5, 4, 5])
squares_y = np.array([2, 3, 6, 6, 7, 7]) - 2



out, figs = plt.subplots(1,3)
figs[0].imshow(pic2)
figs[1].imshow(pic3)
figs[2].imshow(pic1)
for i in range(len(squares_x)):
    rect = patches.Rectangle((squares_x[i]*240+24, squares_y[i]*240+258), 240, 240, fill=True, alpha=0.3, color=(0,1,0))
    figs[2].add_patch(rect)
for i in range(258, 1699, 240):
    figs[2].plot([i,i], [24,2184], 'k-')
for i in range(24, 2185, 240):
    figs[2].plot([258,1698], [i,i], 'k-')






