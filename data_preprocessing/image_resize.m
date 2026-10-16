% Clear the workspace
clear all;clc;

% Open a dialog window to select the directory containing the input images
directory = uigetdir();

% Retrieve all JPG images from the selected directory
files = dir(fullfile(directory, '*.jpg'));

% Define the target dimensions for the resized images
new_size = [16 16];

% Generate the name of the output directory based on the target dimensions
output_directory_name = sprintf('resized_images_%dx%d',new_size(1), new_size(2));

% Construct the full path to the output directory
output_directory = fullfile(directory, output_directory_name);

% Process each image in the selected directory
for i = 1:length(files)

    % Load the current image
    image = imread(fullfile(directory, files(i).name));

    % Resize the image to the specified dimensions
    resized_image = imresize(image, new_size);

    % Extract the filename and extension without the directory path
    [~, name, ext] = fileparts(files(i).name);

    % Save the resized image with a suffix indicating its new dimensions
    imwrite(resized_image,fullfile(output_directory, [name '_16x16' ext]));
end
