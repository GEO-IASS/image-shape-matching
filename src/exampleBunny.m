% Tao Du
% taodu@stanford.edu
% Mar 17, 2015

% Run this script for the chair example.

% Clear.
clear all; clc;
PROJECT_ROOT = '/home/taodu/research/image-shape-matching/';

%% Initialization. Change this for different shapes.
shapeName = 'bunny';

% The following values are used for rendering. Keep in mind they should be
% consistent with what we provide in the pbrt script in ./data/script.
imageSize = [640 480]';  % Image size.
cameraPos = [0 0.08 0.13]';  % Camera position.
cameraLookAt = [0 0 0]';  % Camera lookAt point
cameraUp = [0 1 0]';  % Camera up direction
fov = 75;  % Field of view.

% The (groundtruth) scaling factor.
s = [1.25; 0.8; 1.1];

% The iterations we are interested in. The first and the last iterations
% will be added into iters automatically.
iters = [1, 2];

% The row and column in the grid we want to display the results.
rowInGrid = 1;
colInGrid = 4;

% The color used in displaying the results.
overlapColor = [0.2 0.3 0.7];

%% Read data and optimization.
[V, F] = readObj([PROJECT_ROOT, 'data/shape/', shapeName, '.obj']);
% Shift the bunny by the mean.
V = bsxfun(@minus, V, mean(V, 1));

% Define the lighting.
lightPos = [0.3 0.3 -0.3]';
lightColor = [0.8 0.2 0.4]';

% Get the (groundtruth) transform matrix.
[~, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, cameraLookAt, ...
                          cameraUp, fov, lightPos, lightColor);

% Deformed shape.
featureVertex = bsxfun(@times, V, s');
featureImage = model2Image(featureVertex, M2V, V2P);

% Now we have: V: the original shape; featureVertex: the deformed shape;
% featureImage: the projection of the deformed shape.
[M2V2, V2P2, s2, rms2] = optimizeCameraAndScale(featureImage, V);

% The groundtruth:
% M2V2 = M2V(t up to scale); V2P2 = V2P; s2(:, end) = s up to scale.

%% Display the results.
% A iter-rms plot.
figure;
plot(rms2);
xlabel('iteration'); ylabel('rms');
title('rms vs iteration');

% Write shape data into the file.
originShapeFile = [PROJECT_ROOT, 'data/script/geometry/', shapeName, ...
                   '.pbrt'];
deformedShapeFile = [PROJECT_ROOT, 'data/script/geometry/', shapeName, ...
                     '-scaled.pbrt'];
writeObj2Pbrt(originShapeFile, V, F);
writeObj2Pbrt(deformedShapeFile, featureVertex, F);
                 
% Render the origin model and the deformed model.
PBRT_ROOT = '/home/taodu/research/pbrt-v2/src/bin/pbrt';
originScript = [PROJECT_ROOT, 'data/script/', shapeName, '.pbrt'];
deformedScript = [PROJECT_ROOT, 'data/script/', shapeName, '-scaled.pbrt'];
originImageName = [PROJECT_ROOT, 'data/script/', shapeName, '.exr'];
deformedImageName = [PROJECT_ROOT, 'data/script/', shapeName, ...
                     '-scaled.exr'];
system([PBRT_ROOT, ' --outfile ', originImageName, ...
        ' --quiet ', originScript]);
system([PBRT_ROOT, ' --outfile ', deformedImageName, ...
        ' --quiet ', deformedScript]);
    
% Read the two images.
originImage = exrread(originImageName);
originImage = gammaCorrectImage(originImage);
deformedImage = exrread(deformedImageName);
deformedImage = gammaCorrectImage(deformedImage);

% Display the two images.
figure;
subplot(1, 2, 1); imshow(deformedImage); title('image');
subplot(1, 2, 2); imshow(originImage); title('model');

% Display the intermediate results.
maxIters = length(rms2);

% To display the original model, we need to add [1 1 1]' into s2.
s2 = [[1 1 1]' s2];
iters = [0 iters maxIters] + 1;
numIters = length(iters);

% Now let's get the size of the image.
r = size(deformedImage, 1);
c = size(deformedImage, 2);

% Initialize the space for the grid.
grid = zeros(r * rowInGrid, c * colInGrid, 3);

% Overlap the intermediate shapes and the original image.
for i = 1 : numIters
  iter = iters(i);
  scaleFactor = s2(:, iter);

  % Compute the scaled shape first.
  V3 = bsxfun(@times, V, scaleFactor');

  % Compute the optimized M2V and V2P for this iteration.
  [M2V3, V2P3] = optimizeCamera(featureImage, V3);

  % Now let's compute the projection image.
  projected = rasterize(V3, F, M2V3, V2P3, imageSize);

  % Overlap image.
  I = deformedImage / 2;
  I(:, :, 1) = I(:, :, 1) + projected * overlapColor(1) / 2;
  I(:, :, 2) = I(:, :, 2) + projected * overlapColor(2) / 2;
  I(:, :, 3) = I(:, :, 3) + projected * overlapColor(3) / 2;

  % Compute the row id and the col id.
  [colId, rowId] = ind2sub([colInGrid, rowInGrid], i);
  grid((rowId - 1) * r + 1 : rowId * r, ...
       (colId - 1) * c + 1 : colId * c, :) = I;
  
  % Display the overlapped image.
  figure;
  imshow(I);
  title(['iter ', num2str(iter - 1)]);
end

% Display the grid.
figure;
imshow(grid);

