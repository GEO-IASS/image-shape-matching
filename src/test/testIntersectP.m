% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Test intersectP on a cube.

% Clear.
clear all; clc;

% Read the cube data.
[V, F] = readObj('data/cube.obj');

% Initialize a line.
o = [0 0 1]';
d = [0.25 0 -0.5]';

% The intersection point is expected to be (0.25 0 0.5)'.
[p, faceId, bc] = intersectP(V, F, o, d);
fprintf('p = \n');
disp(p');
fprintf('(0.25 0 0.5) expected.\n');

% Test face and barycentric coordinates.
fprintf('The point given by the barycentric coordinates = \n');
disp((V(F(faceId, :), :)' * bc)');
fprintf('(0.25 0 0.5) expected.\n');

% Check bc is positive.
fprintf('bc = \n');
disp(bc');

%% Change d into (0.75 0 -0.5)'.
d = [0.75 0 -0.5]';
[p, faceId, bc] = intersectP(V, F, o, d);
fprintf('p = \n');
disp(p');
fprintf('(0 0 0) expected.\n');
fprintf('faceId = %d\n', faceId);
fprintf('bc = \n');
disp(bc');
fprintf('(0 0 0) expected.\n');

%% Test the speed of intersectP.
% Read the bunny data.
[V, F] = readObj('data/bunny.obj');
V = alignObj(V);

% Initialize a line.
o = [0 0 0.2]';
d = [0 0 -0.2]';

% Timing.
tic;
[p, faceId, bc] = intersectP(V, F, o, d);
toc;

% Print the results.
fprintf('p = \n');
disp(p');
fprintf('faceId = %d\n', faceId);
fprintf('bc = \n');
disp(bc');