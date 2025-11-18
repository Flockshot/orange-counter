# Orange Counter: Segmentation & Morphological Processing

Developed a MATLAB program to automatically segment and count large and small half-cut oranges in an image (`Oranges.tif`) using color segmentation and advanced morphological operations.

The core of this project is a **morphology-based counting algorithm**, which differentiates between object sizes using only morphological operators, as required by the project constraints.

![MATLAB](https://img.shields.io/badge/MATLAB-R2021a-0076A8.svg?logo=mathworks&logoColor=white)
![Topics](https://img.shields.io/badge/Topics-Image_Segmentation_|_Morphology-blue.svg)

---

## 🔬 Core Methodology

The algorithm identifies and counts the oranges in a three-stage pipeline.

### 1. Color Segmentation (HSI)
The input RGB image is first converted to the **HSI (Hue, Saturation, Intensity)** color space. 

[Image of HSI color space model]
 This is a crucial step because the "orangeness" (Hue) is a much more reliable feature for segmentation than its brightness (Intensity), which varies significantly across the image. A binary mask is created by applying a threshold to the **Hue and Saturation** channels, effectively isolating *only* the orange pixels.

### 2. Morphological Cleaning
The raw binary mask from segmentation contains noise (small, stray pixels) and potential gaps within the oranges. To fix this, a morphological **Opening** operation (an erosion followed by a dilation) is applied.  This process removes the small noise "speckles" and smooths the object boundaries without significantly altering their size, resulting in a clean binary mask where each orange is a distinct "blob".

### 3. Morphology-Based Counting
The key challenge was to count "big" vs. "small" oranges using only morphological operations. This was achieved with the following logic:

1.  **Total Count:** First, a standard connected-component analysis (`bwconncomp`) is run on the *cleaned mask* to get the **total number** of oranges.
2.  **Big Orange Count:** To isolate *only* the big oranges, the cleaned mask is **eroded** using a large structuring element (e.g., a disk). This element is sized to be larger than the small oranges but smaller than the big ones. This erosion operation effectively "eats away" all the small oranges, making them disappear, while only the cores of the big oranges remain. A connected-component analysis is run again on this *eroded* mask to get the **big orange count**.
3.  **Small Orange Count:** The final count is a simple subtraction: `small_oranges = total_oranges - big_oranges`.

This method cleverly uses morphology to filter objects by size before counting.

---

## 📊 Results: Before & After

The algorithm successfully segments the oranges from the background, and the morphological counting logic correctly identifies and differentiates the two size classes, drawing bounding boxes as required.

| Original Image (`Oranges.tif`) | Binary Segmentation Mask (`Figure 1`) | Final Detection (`Figure 2`) |
| :---: | :---: | :---: |
| > **[Image: Original Oranges.tif]** | > **[Image: Cleaned binary mask of oranges]** | > **[Image: Oranges with bounding boxes and counts]** |
| The input image with two sizes of oranges. | The result of HSI thresholding and morphological opening. | The final output with big and small oranges counted and boxed. |

---

## 🚀 How to Run

1.  Open MATLAB.
2.  Place the `orange_counter.m` script (named `A3_StudentID.m` in the spec) in the same directory as the input image, `Oranges.tif`.
3.  Run the script.
4.  The program will process the image and, as required by the project, automatically generate and display two figures:
    * **Figure 1:** The binary segmentation mask.
    * **Figure 2:** The original image with bounding boxes and counts for both "big" and "small" oranges.