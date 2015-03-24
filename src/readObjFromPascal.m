function [ V, F ] = readObjFromPascal( modelName, modelId )
% Tao Du
% taodu@stanford.edu
% Mar 21, 2015
%
% Read 3D objects from Beyond PASCAL dataset.
%
% Input: modelName: a string like 'aeroplane'.
%        modelId: an integer.
% Output: V, F: the same as readObj.

% Define the root of Beyond PASCAL.
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Load the CAD model.
load([PASCAL_ROOT, 'CAD/', modelName, '.mat']);

% Extract V and F from the CAD model.
eval(['V = ', modelName, '(', num2str(modelId), ').vertices;']);
eval(['F = ', modelName, '(', num2str(modelId), ').faces;']);

end

