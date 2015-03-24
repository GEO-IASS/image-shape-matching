function [ I, V, F, featureImage, featureVertex, M2V, V2P, s, rms ] = ...
  optimizePascalExample( modelName, imagesetName, fileName)
% Tao Du
% taodu@stanford.edu
% Mar 21, 2015
%
% Run our optimizeCameraAndScale on Beyond PASCAL dataset.
%
% Input: modelName: a string like 'aeroplane'.
%        imagesetName: a string like 'imagenet'.
%        fileName: a string like 'n02690373_16.mat'.
% Output: I: image we want to match, guaranteed to be double.
%         V, F: shape we want to match.
%         featureImage: n x 2 matrix.
%         featureVertex: n x 3 matrix.
%         M2V: 4 x 4 matrix.
%         V2P: 3 x 3 matrix.
%         s: 3 x iter column vector, each column is the scaling factor
%            after each iteration.
%         rms: 1 x iter row vector.

% Initialize the PASCAL root.
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Read the image we want to match.
I = imread([PASCAL_ROOT, 'Images/', modelName, '_', imagesetName, '/', ...
            fileName, '.JPEG']);
I = im2double(I);

% Load the annotation record.
load([PASCAL_ROOT, 'Annotations/', modelName, '_', imagesetName, ...
      '/', fileName, '.mat']);

% If the number of objects is greater than 1, show a warning message.
if numel(record.objects) > 1
  fprintf('Warning: more than one objects in the image!\n');
end

% Load the model keypoint names.
PROJECT_ROOT = '/home/taodu/research/image-shape-matching/';
load([PROJECT_ROOT, 'data/pascal/', modelName, '.mat']);
keypointNum = numel(keypointNames);

% Fill in featureImage.
anchors = record.objects(1).anchors;
featureImage = zeros(keypointNum, 2);

% status collects all the keypoints' status, and filter out those with
% status ~= 1.
status = zeros(keypointNum, 1);
for i = 1 : keypointNum
  % Get the status of this keypoint.
  eval(['status(i) = anchors.', keypointNames{i}, '.status;']);

  if status(i) ~= 1
    % This keypoint is not visible for some reasons.
    fprintf('Warning: invisible keypoint for %s.%s!\n', ...
            modelName, keypointNames{i});
    % In this case, we set featureImage to be zero.
    eval('featureImage(i, :) = 0;');
  else
    % This keypoint is visible, read the data.
    eval(['featureImage(i, :) = anchors.', keypointNames{i}, '.location;']);
  end
end

% Extract the model ID.
modelId = record.objects(1).cad_index;
featureVertex = readFeatureVertexFromPascal(modelName, modelId);
[V, F] = readObjFromPascal(modelName, modelId);

% Filter out bad correspondences.
featureImage = featureImage(status == 1, :);
featureVertex = featureVertex(status == 1, :);

% Call optimizeCameraAndScale.
[M2V, V2P, s, rms] = optimizeCameraAndScale(featureImage, featureVertex);

end

