% Clear the workspace
clear all;clc;close all;

% Path to the dataset
digitDatasetPath = '////';

% Create an image datastore and automatically assign labels based on the names of the subfolders
imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

% Define the number of images used for training and validation
numTrainFiles = 140;
numValidationFiles = 30;

% Split the dataset into training and temporary subsets
[imdsTrain, imdsTemp] = splitEachLabel(imds, numTrainFiles, 'randomize');

% Divide the remaining images into validation and test subsets
[imdsValidation, imdsTest] = splitEachLabel(imdsTemp, numValidationFiles, 'randomize');

% Define the CNN architecture
layers = [
    % Input layer for RGB images.
    imageInputLayer([16 16 3])

    % First convolutional block
    convolution2dLayer(3, 8, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    % Reduce the spatial dimensions of the feature maps
    maxPooling2dLayer(2, 'Stride', 2)

    % Second convolutional block
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    % Reduce the spatial dimensions of the feature maps
    maxPooling2dLayer(2, 'Stride', 2)

    % Third convolutional block
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    % Reduce the spatial dimensions of the feature maps
    maxPooling2dLayer(2, 'Stride', 2)

    % Fully connected layer
    fullyConnectedLayer(15)

    % Convert class scores into normalized probabilities
    softmaxLayer

    % Classification layer
    classificationLayer
];

% Set the loss threshold used to stop training early
lossThreshold = 0.01;

% Configure the neural network training process
options = trainingOptions('rmsprop', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',50, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',2, ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'OutputFcn', @(info)stop_training(info, lossThreshold));

% CNN training
net = trainNetwork(imdsTrain, layers, options);

% Classify the validation images
YPred = classify(net, imdsValidation);
YValidation = imdsValidation.Labels;

% Generate confusion matrix
confMat = confusionmat(YValidation, YPred);

% Plot the confusion matrix to visualize classification performance
figure;
plotconfusion(YValidation, YPred);
title('Confusion Matrix');

numClasses = numel(categories(YValidation));
precision = zeros(numClasses, 1);
recall = zeros(numClasses, 1);
specificity = zeros(numClasses, 1);

% Calculate precision, sensitivity, and specificity
for i = 1:numClasses

    TP = confMat(i, i);
    FP = sum(confMat(:, i)) - TP;
    FN = sum(confMat(i, :)) - TP;
    TN = sum(confMat(:)) - TP - FP - FN;
    precision(i) = TP / (TP + FP);
    recall(i) = TP / (TP + FN);
    specificity(i) = TN / (TN + FP);
end

mean_precision = sum(precision .* sum(confMat, 2)) / sum(confMat(:));
mean_recall = sum(recall .* sum(confMat, 2)) / sum(confMat(:));
mean_specificity = sum(specificity .* sum(confMat, 2)) / sum(confMat(:));

for i = 1:numClasses
    fprintf('Class: %d\n', i);
    fprintf('Precision: %.2f%%\n', precision(i) * 100);
    fprintf('Sensitivity: %.2f%%\n', recall(i) * 100);
    fprintf('Specificity: %.2f%%\n\n', specificity(i) * 100);
end

% Calculate the overall classification accuracy
accuracy = sum(YPred == YValidation) / numel(YValidation);
disp(['Validation accuracy: ', num2str(accuracy * 100), '%']);

fprintf('Mean Precision: %.2f%%\n', mean_precision * 100);
fprintf('Mean Sensitivity: %.2f%%\n', mean_recall * 100);
fprintf('Mean Specificity: %.2f%%\n', mean_specificity * 100);

% Calculate the F1-score for each class.
F1 = 2 * (precision .* recall) ./ (precision + recall);

mean_F1 = 2 * (mean_precision .* mean_recall) ...
    ./ (mean_precision + mean_recall);

fprintf('Mean F1-score: %.2f%%', mean_F1 * 100);