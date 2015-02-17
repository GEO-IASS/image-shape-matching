% Tao Du
% taodu@stanford.edu
% Feb 16, 2015

% Test optimizeCamera.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/chair.obj');
V = alignObj(V);

% Define the image size.
imageSize = [640 480]';

% Define the camera parameters.
cameraPos = [0.2 0 -0.7]';
cameraLookAt = [0 0 0]';
cameraUp = [0 1 0]';
fov = 90;

% Define the lighting.
lightPos = [0.3 0.3 -0.3]';
lightColor = [0.8 0.2 0.4]';

% Render the bunny.
[I, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, cameraLookAt, ...
                          cameraUp, fov, lightPos, lightColor);
I = gammaCorrectImage(I);

%% Select feature points.
cameraPos = [0.4 0.1 -0.4]';
[featureImage, featureVertex] = selectFeaturePoints(I, V, F, cameraPos);

%% Optimize Camera.
[M2V2, V2P2] = optimizeCamera(featureImage, featureVertex, imageSize);

% The ground truth.
M0 = V2P * M2V(1 : 3, :);

% The estimated results.
M = V2P2 * M2V2(1 : 3, :);