% Tao Du
% taodu@stanford.edu
% Feb 23, 2015

% Test normalizePoint.

% Clear.
clear all; clc;

% Generate random points.
n = 15;
k = 3;
X = rand(n, k);

[P, Y] = normalizePoint(X);

% Display the mean of Y.
fprintf('The mean of Y should be zero:\n');
disp(mean(Y, 1));

% Display the average norm of Y.
fprintf('The average norm of Y:\n');
disp(mean(sqrt(sum(Y.^2, 2))));

% Verify that P * X = Y(extend X and Y to be homogeneous coordinates
% first!).
fprintf('P * X = \n');
disp(P * [X ones(n, 1)]');
fprintf('Y = \n');
disp(Y');