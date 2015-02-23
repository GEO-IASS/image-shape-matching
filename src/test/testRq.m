% Tao Du
% taodu@stanford.edu
% Feb 22, 2015

% Test rq decomposition.

% Clear.
clear all; clc;

% Generate a random 3 x 3 matrix.
A = rand(3, 3);

% Decompose A.
[R, Q] = rq(A);

% Display the results.
fprintf('A = \n');
disp(A);
fprintf('R = \n');
disp(R);
fprintf('Q = \n');
disp(Q);
fprintf('RQ = \n');
disp(R * Q);