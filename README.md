# Hough-Line-Affine-Upgrade

Simple algorithm to automatically remove projective distortion from images using Hough Lines and RANSAC.

Hough lines are found. Then, two lines are randomly selected and their intersection is calculated.
The inliers correspond to Hough lines that pass within a threshold of this intersection.

Note that this does not do a full rectification of the image. To do this, you need to find lines that 
are orthogonal in the real-world, but neither of which can be parallel to the lines in the Hough
inliers.

Results:

Original Image:
![alt text](https://github.com/cdbunker/Hough-Line-Affine-Upgrade/blob/master/amsterdam.jpg)

All Lines:
![alt text](https://github.com/cdbunker/Hough-Line-Affine-Upgrade/blob/master/allLines.PNG)

First Inlier Set:
![alt text](https://github.com/cdbunker/Hough-Line-Affine-Upgrade/blob/master/firstInlier.PNG)

Second Inlier Set:
![alt text](https://github.com/cdbunker/Hough-Line-Affine-Upgrade/blob/master/secondInliers.PNG)

Image with projective distortion Removed:
![alt text](https://github.com/cdbunker/Hough-Line-Affine-Upgrade/blob/master/affine.PNG)
