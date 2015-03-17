% Tao Du
% taodu@stanford.edu
% Feb 16, 2015

% Test optimizeCameraAndScale.

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

% Render the chair.
[I, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, cameraLookAt, ...
                          cameraUp, fov, lightPos, lightColor);
I = gammaCorrectImage(I);

%% Deform the shape.
% s ranges from 0.5 to 1.5.
s = rand(3, 1) + 0.5;
featureVertex = bsxfun(@times, V, s');
featureImage = model2Image(featureVertex, M2V, V2P);

% Now we have: V: the original shape; featureVertex: the deformed shape;
% featureImage: the projection of the deformed shape.
[M2V2, V2P2, s2] = optimizeCameraAndScale(featureImage, V);

% The groundtruth:
% M2V2 = M2V; V2P2 = V2P; s2 = s;

% Let's compute the rms error.
rms = evaluateHomography(M2V, V2P, featureImage, featureVertex);
rms2 = evaluateHomography(M2V2, V2P2, featureImage, bsxfun(@times, V, s2'));