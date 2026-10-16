function Image_augmentation(input_directory, output_directory, augmentation_Factor)

% Retrieve all JPG images from the input directory
fileList = dir(fullfile(input_directory, '*.jpg'));

% Process each image in the input directory
for i = 1:length(fileList)

    % Load the original image
    originalImage = imread(fullfile(input_directory, fileList(i).name));

    % Extract the filename and extension without the directory path
    [~, name, ext] = fileparts(fileList(i).name);

    % Save a copy of the original image in the output directory
    imwrite(originalImage, fullfile(output_directory, [name '_oryginalny' ext]));

    % Generate additional images using random augmentation techniques
    for j = 1:augmentation_Factor-1

        augmentedImage = originalImage;

        % Randomly select one of five augmentation techniques
        augmentationType = randi([1, 5]);

        switch augmentationType

            case 1
                % Brighten the image by applying a randomly selected gamma correction factor
                brightnessFactor = 0.3 + rand()*0.5;
                augmentedImage = imadjust(augmentedImage, [], [], brightnessFactor);
                augmentationName = '_brighten';

            case 2
                % Darken the image by applying a randomly selected gamma correction factor
                darknessFactor = 1.2 + rand()*0.6;
                augmentedImage = imadjust(augmentedImage, [], [], darknessFactor);
                augmentationName = '_darken';

            case 3
                % Rotate the image by a random angle between 2 and 8 degrees
                angle = 2 + rand()*6;
                augmentedImage = imrotate(augmentedImage, angle, 'bilinear', 'crop');
                augmentationName = '_rotated';

            case 4
                % Apply a horizontal shear transformation with a random shear factor between 0 and 0.1
                shearFactor = 0.1*rand();
                tform = affine2d([1 0 0; shearFactor 1 0; 0 0 1]);

                % Define the output spatial reference to preserve the original image dimensions
                outputView = imref2d(size(originalImage));

                % Apply the affine transformation
                augmentedImage = imwarp(augmentedImage, tform, 'OutputView', outputView);
                augmentationName = '_sheared';

            case 5
                % Apply Gaussian blur using a randomly selected standard deviation between 0.5 and 1.5
                sigma = 0.5 + rand();
                augmentedImage = imgaussfilt(augmentedImage, sigma);
                augmentationName = '_blurred';
        end

        % Save the augmented image using a filename that identifies
        % the augmentation type and the generated image index.
        imwrite(augmentedImage, fullfile(output_directory, ...
            [name augmentationName num2str(j) ext]));
    end
end
end
