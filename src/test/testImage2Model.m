% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Test image2Model.

% Clear.
clear all; clc;

% Read V and F from .obj files.
[V, F] = readObj('data/bunny.obj');
V = alignObj(V);

% Define the image size.
imageSize = [640 480]';

% Define the camera parameters.
cameraPos = [0 0 0.2]';
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

%% Test image2Model.
% Project V by M2V and V2P.
P = model2Image(V, M2V, V2P);

% Convert it back to V2.
V2 = image2Model(P, M2V, V2P);

% Now, verify V, V2 and cameraPos are colinear.
D = bsxfun(@minus, V, cameraPos');
D2 = bsxfun(@minus, V2, cameraPos');

% If image2Model is correct, then D and D2 should be parallel. That means,
% if we normalize them, they should be the same.

% Normalize D.
D = bsxfun(@rdivide, D, sqrt(sum(D.^2, 2)));

% Normalize D2.
D2 = bsxfun(@rdivide, D2, sqrt(sum(D2.^2, 2)));

% Are they the same?
fprintf('norm(D) = %f, norm(D2) = %f, norm(D - D2) = %f\n', norm(D), ...
        norm(D2), norm(D - D2));
