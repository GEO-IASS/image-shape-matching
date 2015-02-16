function [ featureImage, featureVertex ] = ...
  selectFeaturePoints( I, V, F, cameraPos, cameraLookAt, cameraUp, fov )
% Tao Du
% taodu@stanford.edu
% Feb 11, 2015
%
% Select feature points from both images and 3D shapes.
% Input: I: an image.
%        V, F: vertices and faces. Output from readObj. Assume V has been
%              aligned by calling V = alignObj(V).
%        cameraPos etc: optional parameters. See explanations in renderObj.
% Output: featureImage: n x 2 matrix. Each row is a feature point in the
%                       image space. You can call image2Pixel to convert it
%                       into pixel space.
%         featureVertex: n x 3 matrix. Each row is a vertex corresponding
%                        to a feature pixel.

%% Fill optional parameters.
if nargin < 7
  fov = 90;
end
if nargin < 6
  cameraUp = [0 1 0]';
end
if nargin < 5
  cameraLookAt = [0 0 0]';
end

% Compute the size of the bounding box of V, and scale it to get dist such
% that (dist, dist, dist) is guaranteed to be outside of the bounding box.
% Used in cameraPos and lightPos.
dist = max(max(V, [], 1)) * 1.2;

% If cameraPos is not provided, put it at (dist, dist, dist).
if nargin < 4
  cameraPos = ones(3, 1) * dist;
end

% Set up the image size. Note that imageSize = [width height]'.
imageSize = [size(I, 2), size(I, 1)]';

% Set up 4 lights, guaranteed to be outside the shape.
lightPos = [1 1 -1 -1; 1 1 1 1; 1 -1 1 -1] * dist;
lightColor = rand(3, 4);

% Render the shape.
[I2, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, cameraLookAt, ...
                           cameraUp, fov, lightPos, lightColor);
I2 = gammaCorrectImage(I2);

%% Plot I and I2.
subplot(1, 2, 1); imshow(I); title('image');
subplot(1, 2, 2); imshow(I2); title('shape');

%% Select the feature points.
% Select all the feature points from ginput. We assume the feature points
% are selected alternatively between image and shape, i.e., we first pick
% up a feature point in the image, then select the corresponding point in
% the shape, then the second image feature point, the second shape feature
% point, etc.
v = ginput;

% Get the number of feature points.
n = size(v, 1) / 2;

% Initialize featureImage and featureVertex.
featureImage = ginput2Image(v(1 : 2 : end, :));
featureVertex = zeros(n, 3);

% Convert all the feature points in the shape into the image space.
featureShapeImage = ginput2Image(v(2 : 2 : end, :));

% Convert it into model space.
featureModel = image2Model(featureShapeImage, M2V, V2P);

% Compute the direction for each vertex.
featureDir = bsxfun(@minus, featureModel, cameraPos');

% Loop over all the vertices.
for i = 1 : n
  % Compute the intersection point.
  featureVertex(i, :) = intersectP(V, F, cameraPos, featureDir(i, :)');
end

%% Display featurePixel and featureVertex in I and I2.
% Generate random colors.
c = rand(n, 3);

% Plot feature points in I.
I = plotFeaturePoint(I, image2Pixel(featureImage), c);

% Plot feature points in I2.
% Compute the corresponding pixels for featureVertex.
p = image2Pixel(model2Image(featureVertex, M2V, V2P));
I2 = plotFeaturePoint(I2, p, c);

% Display the results.
subplot(1, 2, 1); imshow(I); title('image');
subplot(1, 2, 2); imshow(I2); title('shape');

end

