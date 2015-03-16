% Tao Du
% taodu@stanford.edu
% Mar 8, 2015

% Test getCameraPos.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/bunny.obj');
V = alignObj(V);

% Define the image size.
imageSize = [640 480]';

% Define the camera parameters.
cameraPos = [0.1 0.4 0.2]';
cameraLookAt = [0 0 0]';
cameraUp = [1 0 0]';
fov = 90;

% Define the lighting.
lightPos = [0.3 0.3 0.3]';
lightColor = [0.8 0.2 0.4]';

% Render the bunny.
[~, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, ...
                          cameraLookAt, cameraUp, fov, ...
                          lightPos, lightColor);

%% Test getCameraPos.
cameraPos2 = getCameraPos(M2V);

% Compare cameraPos and cameraPos2.
fprintf('cameraPos =\n');
disp(cameraPos);
fprintf('cameraPos2 =\n');
disp(cameraPos2);
