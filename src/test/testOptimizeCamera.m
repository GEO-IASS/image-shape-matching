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

%% Optimize camera.
[M2V2, V2P2] = optimizeCamera(featureImage, featureVertex, imageSize);

% Now let's compare (M2V, V2P) and (M2V2, V2P2).
% Quantitatively: we project feature points back into the image with M2V2
% and V2P2, then compute the pixel distances between the projected
% featureVertex and featureImage.

% Compute the rms from (M2V, V2P), this serves as the ground truth, and the
% rms should be fairly small.
rms = evaluateHomography(M2V, V2P, featureImage, featureVertex);
fprintf('rms = %f\n', rms);

% Compute the rms from (M2V2, V2P2), this comes from our optimzation, and
% our goal is to make this rms as small as possible.
rms2 = evaluateHomography(M2V2, V2P2, featureImage, featureVertex);
fprintf('rms2 = %f\n', rms2);

%% Error analysis:
% Qualitatively: we compute cameraPos, cameraLookAt, cameraUp from M2V2,
% and fov from V2P2, and render the shape to get a new image I3. We blend I
% and I3 for comparison.
% See comments in renderObj for the math.

% Extract view2Model first.
view2Model = M2V2(1 : 3, 1 : 3)';

% Recover cameraPos2.
cameraPos2 = -view2Model * M2V2(1 : 3, 4);

% Recover cameraLookAt2.
x = view2Model(:, 1); y = view2Model(:, 2); z = view2Model(:, 3);
cameraLookAt2 = z + cameraPos2;

% Recover cameraUp2.
cameraUp2 = y;

% Extract height and width.
h = V2P2(2, 3) * 2;
w = V2P2(1, 3) * 2;

% Recover angleY.
tanY = h / 2 / V2P2(1, 1);
angleY = atan(tanY);

% Recover angleX.
tanX = tanY / h * w;
angleX = atan(tanX);

% fov2
fov2 = rad2deg(min(angleX, angleY)) * 2;

% As a sanity check, M2V3 and V2P3 should be identical to M2V2 and V2P2.
% Use random light positions and light colors.

% lightPos and lightPos2 are symmetric w.r.t. z-y plane, where z and y are
% from view2Model.
lightPos2 = lightPos - 2 * (lightPos' * x) * x;
lightColor2 = rand(3, 1);
[I3, M2V3, V2P3] = renderObj(V, F, imageSize, cameraPos2, ...
                             cameraLookAt2, cameraUp2, fov2, lightPos2, ...
                             lightColor2);
I3 = gammaCorrectImage(I3);
fprintf('norm(M2V2) = %f, norm(M2V3) = %f, norm(M2V2 - M2V3) = %f\n', ...
        norm(M2V2), norm(M2V3), norm(M2V2 - M2V3));
fprintf('norm(V2P2) = %f, norm(V2P3) = %f, norm(V2P2 - V2P3) = %f\n', ...
        norm(V2P2), norm(V2P3), norm(V2P2 - V2P3));
                         
% Now blend I and I3 to see the results.
subplot(1, 3, 1); imshow(I); title('I');
subplot(1, 3, 2); imshow(I3); title('I3');
subplot(1, 3, 3); imshow((I + I3) / 2); title('Blending I and I3');