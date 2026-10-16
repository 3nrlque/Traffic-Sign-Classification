function noise_addition(noise_level)

% Open a dialog window to select the directory containing the input images
directory_path = uigetdir();

% Stop execution if no directory was selected.
if directory_path == 0
    disp('No directory selected');
    return;
end

% Retrieve all JPG images from the selected directory
image_files = dir(fullfile(directory_path, '*.jpg'));

% Define the output directory for the noisy images
output_directory = fullfile(directory_path, 'noisy_images');

% Create the output directory if it does not already exist
if ~exist(output_directory, 'dir')
    mkdir(output_directory);
end

% Process each image in the selected directory
for i = 1:length(image_files)

    % Construct the full path to the current image
    img_path = fullfile(directory_path, image_files(i).name);

    % Load the original image
    original_img = imread(img_path);

    % Add Gaussian noise with zero mean and the specified variance
    noisy_img = imnoise(original_img, 'gaussian', 0, noise_level);

    % Extract the filename and extension without the directory path
    [~, name, ext] = fileparts(image_files(i).name);

    % Generate an output filename containing the noise variance
    output_name = sprintf('%s_gauss_%.3f%s', name, noise_level, ext);

    % Construct the full path for the output image
    output_path = fullfile(output_directory, output_name);

    % Save the noisy image to the output directory
    imwrite(noisy_img, output_path);
end
end
