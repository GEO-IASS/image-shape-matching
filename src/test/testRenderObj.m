% Tao Du
% taodu@stanford.edu
% Feb 12, 2015

% Test renderObj. Especially 
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

%% Test M2V and V2P.
% Extract R and T first.
R = M2V(1 : 3, 1 : 3);
T = M2V(1 : 3, 4);

% Combine M2V and V2P together.
R = V2P * R;
T = V2P * T;

% Consider the upper right corner in the cube. The expected value in the
% image coordinates should be (600, 120).
% Point in the model coordinates.
pModel = [-0.5; 0.5; 0.5];
pImage = R * pModel + T;
pImage = pImage / pImage(end);
fprintf('The upper right corner = \n');
disp(pImage');

% The upper left corner: (360, 120).
pModel = [0.5; 0.5; 0.5];
pImage = R * pModel + T;
pImage = pImage / pImage(end);
fprintf('The upper left corner = \n');
disp(pImage');

% The lower left corner: (360, 360).
pModel = [0.5; -0.5; 0.5];
pImage = R * pModel + T;
pImage = pImage / pImage(end);
fprintf('The lower left corner = \n');
disp(pImage');

% The lower right corner: (600, 360).
pModel = [-0.5; -0.5; 0.5];
pImage = R * pModel + T;
pImage = pImage / pImage(end);
fprintf('The lower right corner = \n');
disp(pImage');