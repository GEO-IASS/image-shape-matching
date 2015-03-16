% Tao Du
% taodu@stanford.edu
% Mar 16, 2015

% Test optimizeScale.

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

% Now deform featureVertex.
s = rand(1, 3);
featureVertex = bsxfun(@times, V, s);
featureImage = model2Image(featureVertex, M2V, V2P);

% V: vertices before deformation.
% featureVertex: vertices after deformation.
% featureImage: projection using M2V and V2P.
s2 = optimizeScale(featureImage, V, M2V, V2P);

% Ideally s == s2.
fprintf('s = \n');
disp(s);
fprintf('s2 = \n');
disp(s2');
