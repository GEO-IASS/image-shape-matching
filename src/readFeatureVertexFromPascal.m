function [ featureVertex ] = ...
  readFeatureVertexFromPascal( modelName, modelId )
% Tao Du
% taodu@stanford.edu
% Mar 21, 2015
%
% Given modelName and modelId, read its keypoints from Beyond PASCAL.
% All the keypoints are stored in the /CAD folder.
%
% Input: modelName: a string like 'aeroplane'.
%        modelId: an integer.
% Output: featureVertex: a n x 3 matrix. Each row is a feature vertex. The
%                        order is defined in ../data/pascal/modelName.mat.

% Load CAD model.
PASCAL_ROOT = '/home/taodu/research/pascal/';
load([PASCAL_ROOT, 'CAD/', modelName, '.mat']);
% Ues model to access the keypoints.
eval(['model = ', modelName, '(', num2str(modelId), ');']);

% Load all the keypoint names.
PROJECT_ROOT = '/home/taodu/research/image-shape-matching/';
load([PROJECT_ROOT, 'data/pascal/', modelName, '.mat']);

% Get the number of feature points.
n = length(keypointNames);
featureVertex = zeros(n, 3);

% Loop over all the vertices.
for i = 1 : n
  eval(['featureVertex(i, :) = model.', keypointNames{i}, ';']);
end

end

