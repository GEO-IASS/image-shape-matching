% Tao Du
% taodu@stanford.edu
% Feb 16, 2015

% Test optimizeCamera.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/chair.obj');
V = alignObj(V);

% Define the image size.
imageSize = [640 480]';

% Define the camera parameters.
cameraPos = [0.2 0 -0.7]';
cameraLookAt = [0 0 0]';
cameraUp = [0 1 0]';
fov = 90;

% Define the lighting.
lightPos = [0.3 0.3 -0.3]';
lightColor = [0.8 0.2 0.4]';

% Render the bunny.
[I, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, cameraLookAt, ...
                          cameraUp, fov, lightPos, lightColor);
I = gammaCorrectImage(I);

%% Select feature points.
cameraPos = [0.4 0.1 -0.4]';
[featureImage, featureVertex] = selectFeaturePoints(I, V, F, cameraPos);

%% Optimize camera.
[M2V2, V2P2] = optimizeCamera(featureImage, featureVertex);

% Now let's compare (M2V, V2P) and (M2V2, V2P2).
% Quantitatively: we project feature points back into the image with M2V2
% and V2P2, then compute the pixel distances between the projected
% featureVertex and featureImage.

% Compute the rms from (M2V, V2P), this serves as the ground truth, and the
% rms should be fairly small.
[rms, featureImage1] = evaluateHomography(M2V, V2P, ...
                                          featureImage, featureVertex);
fprintf('rms = %f\n', rms);

% Compute the rms from (M2V2, V2P2), this comes from our optimzation, and
% our goal is to make this rms as small as possible.
[rms2, featureImage2] = evaluateHomography(M2V2, V2P2, ...
                                           featureImage, featureVertex);
fprintf('rms2 = %f\n', rms2);

%% Display the results.
% We plan to place three images in a row: I1 is I with red featureImage,
% green featureImage1 and blue featureImage2. I2 is the projected image of
% the whole triangle mesh. I3 is the blending result of I1 and I2.

% Close the other figures;
close all;

% Compute I1.
% Red featureImage is the feature pixels selected by the user.
% Green featureImage1 is the projected feature pixels from M2V and V2P,
% which is the ground truth pixels for the projection matrix in I.
% Blue featureImage2 is hte projected feature pixels from M2V2 and V2P2,
% which is computed by the estimated projection matrix.
I1 = plotFeaturePoint(I, image2Pixel(featureImage), [1 0 0]);
I1 = plotFeaturePoint(I1, image2Pixel(featureImage1), [0 1 0]);
I1 = plotFeaturePoint(I1, image2Pixel(featureImage2), [0 0 1]);
subplot(1, 3, 1); imshow(I1);

% Compute I2.
I2 = rasterize(V, F, M2V2, V2P2, imageSize);
subplot(1, 3, 2); imshow(I2);

% Compute I3.
I3 = I1 / 2;
% Blend I2 and I1 in each channel.
I3(:, :, 1) = I3(:, :, 1) + I2 / 2;
I3(:, :, 2) = I3(:, :, 2) + I2 / 2;
I3(:, :, 3) = I3(:, :, 3) + I2 / 2;
subplot(1, 3, 3); imshow(I3);
