% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Test model2Image. Basically we read a bunny obj, then render it by PBRT,
% finally we call model2Image and project all the vertices into the image,
% then blend them for comparison. Incidentally, this script tests
% image2Pixel.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/bunny.obj');
V = alignObj(V);

% Define the image size.
imageSize = [640 480]';

% Define the camera parameters.
cameraPos = [0 0 0.2]';
cameraLookAt = [0 0 0]';
cameraUp = [1 0 0]';
fov = 90;

% Define the lighting.
lightPos = [0.3 0.3 0.3]';
lightColor = [0.8 0.2 0.4]';

% Render the bunny.
[I, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, ...
                          cameraLookAt, cameraUp, fov, ...
                          lightPos, lightColor);
I = gammaCorrectImage(I);

%% Project V by M2V and V2P.
P = model2Image(V, M2V, V2P);

% Initialize a black-and-white image.
I2 = zeros(size(I));

% Plot all the pixels from P.
P = image2Pixel(P);
n = size(P, 1);
for i = 1 : n
  I2(P(i, 1), P(i, 2), :) = 1;
end

%% Display I and I2.
subplot(1, 3, 1), imshow(I);
subplot(1, 3, 2), imshow(I2);

% Blend I and I2.
subplot(1, 3, 3), imshow((I + I2) / 2);
