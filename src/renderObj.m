function [ I, model2View, view2Projection ] = renderObj( V, F, ...
  imageSize, cameraPos, cameraLookAt, cameraUp, fov, lightPos, lightColor )
% Tao Du
% taodu@stanford.edu
% Feb 12, 2015

% Given a object (V, F), render it with given camera position and light
% position. It generates a temp folder containg the pbrt script and the
% image, read the image from file, and finally delete the temp folder.
% Input: V, F. Output from readObj.
%        imageSize: a 2 x 1 column vector, height x width.
%        cameraPos: a 3 x 1 column vector. Representing the camera position
%                   in the world coordinates.
%        cameraLookAt: a 3 x 1 column vector. Representing the point our
%                      camera is looking at.
%        cameraUp: a 3 x 1 column vector. Representing the up direction of
%                  our camera. 
%        fov: a scalar in degree.
%        lightPos: a 3 x 1 column vector. Representing a point light in the
%                  world coordinates.
%        lightColor: a 3 x 1 column vector between [0, 1].
% Output: I: a imageSize(1) x imageSize(2) x 3 image.
%         model2View: a 3 x 3 matrix. Given a 3D point p in the model
%                     coordinates, model2View * p gives its coordinates in
%                     the camera coorindates defined by camreaPos,
%                     cameraLookAt and cameraUp.
%         view2Projection: a 3 x 3 matrix. Given a 3D point p in the camera
%                          coordinates, view2Projection * p gives the
%                          homogeneous coordinates in the film plane.

% Define the PBRT root.
PBRT_ROOT = '/home/taodu/research/pbrt-v2/src/bin/pbrt';

% Generate a temp folder.

% Build the rendering script.

% Call PBRT to render the image.

% Read I from the rendering image.

% Compute model2View and view2Projection.

% Delete the temp folder.

end

