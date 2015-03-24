% Tao Du
% taodu@stanford.edu
% Mar 24, 2015

% Only use this script in exampleModel.

% Initialization. Change this for different shapes.
shapeName = 'dragon';

% The following values are used for rendering. Keep in mind they should be
% consistent with what we provide in the pbrt script in ./data/script.
imageSize = [640 480]';  % Image size.
cameraPos = [-0.15 0.12 0.17]';  % Camera position.
cameraLookAt = [0 0 0]';  % Camera lookAt point
cameraUp = [0 1 0]';  % Camera up direction
fov = 75;  % Field of view.

% The (groundtruth) scaling factor.
s = [1.3; 0.7; 0.9];

% The iterations we are interested in. The first and the last iterations
% will be added into iters automatically. We will display the results AFTER
% iterations shown in iters.
iters = [2, 3, 5, 10, 25, 50];

% The row and column in the grid we want to display the results.
rowInGrid = 2;
colInGrid = 4;

% The color used in displaying the results.
overlapColor = [0.2 0.3 0.7];
