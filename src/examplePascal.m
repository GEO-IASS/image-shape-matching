% Tao Du
% taodu@stanford.edu
% Mar 24, 2015

% Run this script for loading examples from Beyond PASCAL.

% Clear.
clear all; clc; close all;
% Initialize the paths.
PASCAL_ROOT = '/home/taodu/research/pascal/';
PROJECT_ROOT = '/home/taodu/research/image-shape-matching/';

%% Initialization. Change this for different shapes.
modelName = 'aeroplane';
imagesetName = 'imagenet';
fileName = 'n02690373_101';

% The iterations we are interested in. The first and the last iterations
% will be added into iters automatically.
iters = [2, 10, 50, 100, 200, 500];

% The row and column in the grid we want to display the results.
rowInGrid = 2;
colInGrid = 4;

% The overlapColor used in blending the image and model.
overlapColor = [0.2, 0.3, 0.7];

% End of initialization.

%% Optimization.
[I, V, F, featureImage, featureVertex, M2V, V2P, s, rms] = ...
    optimizePascalExample(modelName, imagesetName, fileName);

% Display the image we want to match.
figure;
imshow(I);
title('image');

% Display the model we want to match.
figure;
trimesh(F, V(:, 1), V(:, 2), V(:, 3));
title('model');

%% Display the results.
% A iter-rms plot.
figure;
plot(1 : length(rms), rms);
xlabel('iteration'); ylabel('rms');
title('rms vs iteration');

% Display the intermediate results.
maxIters = length(rms);
s = [[1 1 1]' s];
iters = [1 iters maxIters];
numIters = length(iters);

% Now let's get the size of the image.
r = size(I, 1);
c = size(I, 2);
imageSize = [c, r]';

% Initialize the space for the grid.
grid = zeros(r * rowInGrid, c * colInGrid, 3);

% Overlap the intermediate shapes and the original image.
for i = 1 : numIters
  iter = iters(i);
  % scaleFactor is the scaling factor BEFORE the iteration we are
  % interested in.
  scaleFactor = s(:, iter);

  % Compute the scaled shape first. This is the shape BEFORE we enter the
  % iteration we are interested in.
  featureVertex2 = bsxfun(@times, featureVertex, scaleFactor');

  % Compute the optimized M2V and V2P for this iteration. This is the
  % camera matrix AFTER the iteration we are interested in.
  [M2V2, V2P2] = optimizeCamera(featureImage, featureVertex2);

  % Next, let's compute the shape AFTER the iteration.
  V2 = bsxfun(@times, V, s(:, iter + 1)');

  % Now let's compute the projection image.
  projected = rasterize(V2, F, M2V2, V2P2, imageSize);

  % Overlap image.
  I2 = I / 2;
  I2(:, :, 1) = I2(:, :, 1) + projected * overlapColor(1) / 2;
  I2(:, :, 2) = I2(:, :, 2) + projected * overlapColor(2) / 2;
  I2(:, :, 3) = I2(:, :, 3) + projected * overlapColor(3) / 2;

  % Compute the row id and the col id.
  [colId, rowId] = ind2sub([colInGrid, rowInGrid], i);
  grid((rowId - 1) * r + 1 : rowId * r, ...
       (colId - 1) * c + 1 : colId * c, :) = I2;
  
  % Display the overlapped image.
  figure;
  imshow(I2);
  title(['after iter ', num2str(iter)]);
end

% Display the grid.
figure;
imshow(grid);
