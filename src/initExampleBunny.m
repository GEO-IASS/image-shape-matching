% Tao Du
% taodu@stanford.edu
% Mar 24, 2015

% Only use this script in exampleModel.

% Initialization. Change this for different shapes.
shapeName = 'bunny';

% The following values are used for rendering. Keep in mind they should be
% consistent with what we provide in the pbrt script in ./data/script.
imageSize = [640 480]';  % Image size.
cameraPos = [0 0.08 0.13]';  % Camera position.
cameraLookAt = [0 0 0]';  % Camera lookAt point
cameraUp = [0 1 0]';  % Camera up direction
fov = 75;  % Field of view.

% The (groundtruth) scaling factor.
s = [1.25; 0.8; 1.1];

% The iterations we are interested in. The first and the last iterations
% will be added into iters automatically. We will display the results AFTER
% iterations shown in iters.
iters = [2];

% The row and column in the grid we want to display the results.
rowInGrid = 1;
colInGrid = 3;

% The color used in displaying the results.
overlapColor = [0.2 0.3 0.7];
