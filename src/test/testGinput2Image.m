% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Test ginput2Image. Ideally, if P2 = ginput2Image(P1), then we expect P1
% and P2 lie on the same pixels in the image.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/cube.obj');

% The camera coordinate is:
% x: left to right
% y: down to up
% z: outside to inside.
% Note that this coordinate is left-handed.

% Define the image size.
imageSize = [960 480]';

% Define the camera parameters.
cameraPos = [0 0 1.5]';
cameraLookAt = [0 0 0]';
cameraUp = [0 1 0]';
fov = 90;

% Define the lighting.
lightPos = [1 1 1]';
lightColor = [0.8 0.2 0.4]';

% Render the cube. The image should be filled exactly the whole cube.
[I, M2V, V2P] = renderObj(V, F, imageSize, cameraPos, ...
                          cameraLookAt, cameraUp, fov, ...
                          lightPos, lightColor);
I = gammaCorrectImage(I);

% Display I.
imshow(I);

%% Test ginput2Image.
% Let's click on the top right corner of the cube. If everything is
% correct, then we expect the pixel (121, 600) to be white.
P = ginput(1);

% Test ginput2Image.
P2 = ginput2Image(P);

%  Coloer P2 to be white.
P3 = image2Pixel(P2);
I(P3(1), P3(2), :) = 1;
imshow(I);
