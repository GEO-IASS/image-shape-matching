% Tao Du
% taodu@stanford.edu
% Feb 12, 2015

% Test readObj. Read a cube from a .obj file.

% Clear.
clear all; clc;

% Read obj files.
[V, F] = readObj('cube.obj');

% Dipslay V and F.
fprintf('V = \n');
disp(V);
fprintf('F = \n');
disp(F);