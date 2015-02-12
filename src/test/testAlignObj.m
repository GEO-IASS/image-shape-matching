% Tao Du
% taodu@stanford.edu
% Feb 12, 2015

% Test alignObj.
% Input: a rotated and translated cube.
% Output: the aligned cube.

% Clear.
clear all; clc;

% Generate a rotation matrix.
[R, ~, ~] = svd(rand(3, 3));

% Generate a translate vector.
T = rand(3, 1);

% Generate an aligned cube.
V = [3 2 1; 3 2 -1; 3 -2 1; 3 -2 -1; -3 2 1; -3 2 -1; -3 -2 1; -3 -2 -1];

% Rotate and translate it.
V2 = bsxfun(@plus, R * V', T)';

% Run alignObj.
V3 = alignObj(V2);

% Compare V and V3.
fprintf('V = \n');
disp(V);
fprintf('V2 = \n');
disp(V2);
fprintf('V3 = \n');
disp(V3);