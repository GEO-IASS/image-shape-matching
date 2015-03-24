% Tao Du
% taodu@stanford.edu
% Mar 21, 2015

% Test readFeatureVertexFromPascal.

% Clear.
clear all; clc;

% Define the pascal path.
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Test with the 3rd aeroplane model.
load([PASCAL_ROOT, 'CAD/aeroplane.mat']);
model = aeroplane(3);

% Call our readFeatureVertexFromPascal function.
featureVertex = readFeatureVertexFromPascal('aeroplane', 3);

% Display model and featureVertex.
disp(model);
disp(featureVertex);