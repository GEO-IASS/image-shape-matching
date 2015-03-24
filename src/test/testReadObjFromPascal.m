% Tao Du
% taodu@stanford.edu
% Mar 21, 2015

% Test readObjFromPascal.

% Clear.
clear all; clc;
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Test the 3rd aeroplane model.
load([PASCAL_ROOT, 'CAD/aeroplane.mat']);
V = aeroplane(3).vertices;
F = aeroplane(3).faces;

% Now test readObjFromPascal.
[V2, F2] = readObjFromPascal('aeroplane', 3);

% Compare V and F.
fprintf('norm(V2 - V) = %f, norm(F2 - F) = %f\n', ...
        norm(V2 - V), norm(F2 - F));