# Traffic Sign Classification with CNN

## Project overview

The goal of this project is to build and evaluate an image-classification model that
recognizes 15 classes of traffic signs. This type of system can
serve as a learning prototype for traffic-sign recognition in
driver-assistance systems and autonomous vehicles.

The project was developed using MATLAB and Deep Learning Toolbox
functions.

## Dataset

The project uses the [Polish Traffic Signs Dataset](https://www.kaggle.com/datasets/chriskjm/polish-traffic-signs-dataset), obtained from Kaggle.

*   The original dataset contained 20 traffic-sign classes.
*   Classes with too few examples were removed, leaving 15 classes.
*   For classes with fewer than 200 examples, random data augmentation
    was applied. The reported transformations include brightening,
    darkening, rotation, skewing, and blurring.
*   The dataset was split into 70% for training, 15% for validation, and 15% for testing.

<p align="center">
<img width="70%" alt="Class distibution before SMOTE" src="https://github.com/3nrlque/Traffic-Sign-Classification/blob/main/images/dataset_examples.png" />
</p>

> **Dataset access:** Obtain the dataset from its provider and review
> its terms of use. This repository does not claim ownership of the
> original images or grant redistribution rights.

## Model architecture

The CNN implemented in `CNN.m` contains three convolutional blocks. Each block consists of:

1.  A convolutional layer
2.  Batch normalization
3.  ReLU activation
4.  Max pooling

The feature maps are passed to a fully connected layer with 15 outputs,
followed by Softmax and a classification layer.

## Training configuration

-   **Optimizer:** RMSProp
-   **Initial learning rate:** `0.01`
-   **Maximum epochs:** `50`
-   **Validation frequency:** every 2 iterations
-   **Early stopping:** stop when the training loss falls below `0.01`

## Experiments

The accompanying report compares the effects of the following factors:

-   **Image resolution:** 128 × 128, 64 × 64, 32 × 32, 16 × 16, and 8 × 8 pixels
-   **Network depth:** different numbers of convolutional blocks
-   **Optimization algorithm:** SGDM, Adam, and RMSProp
-   **Gaussian noise:** noise levels from 0% to 20%
-   **Network depth under heavy noise:** comparison of model
    configurations at 20% noise

These experiments explore the trade-off between classification
performance, model complexity, and training time.

## Results

The setup featuring three layers, RMSProp, and uncorrupted input images proved to be the top-performing model.

| Metric | result |
| --- | --- |
| Accuracy | 98.89% |
| Recall | 98.89% |
| Precision | 98.90% |
| Specificity | 99.92% |
| F1-score | 98.90% |

<p align="center">
<img width="70%" alt="Class distibution before SMOTE" src="https://github.com/3nrlque/Traffic-Sign-Classification/blob/main/images/confusion_matrix.png" />
</p>