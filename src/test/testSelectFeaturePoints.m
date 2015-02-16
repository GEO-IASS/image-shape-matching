% Tao Du
% taodu@stanford.edu
% Feb 16, 2015

% Test selectFeaturePoints.

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
I = renderObj(V, F, imageSize, cameraPos, cameraLookAt, cameraUp, fov, ...
              lightPos, lightColor);
I = gammaCorrectImage(I);

%% Pass all the camera parameters. The positions of the shape in the two
% images should be identical.
selectFeaturePoints(I, V, F, cameraPos, cameraLookAt, cameraUp, fov);

%% Second, try different cameraPos, and use default cameraLookAt, cameraUp
% and fov.
cameraPos = [0.4 0.1 -0.4]';
selectFeaturePoints(I, V, F, cameraPos);