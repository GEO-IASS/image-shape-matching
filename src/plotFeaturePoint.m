function [ I ] = plotFeaturePoint( I, p, c )
% Tao Du
% taodu@stanford.edu
% Feb 16, 2015
%
% Given an image I, a pixel p, and a color c, plot a cross centered at p.
%
% Input: I: a row x column x 3 image. The range is [0, 1].
%        p: a n x 2 matrix. Each row is a pixel we want to plot.
%        c: a n x 3 matrix, or a 1 x 3 row vector within the range [0, 1].
%           Each row is the color we want to use to plot the corresponding
%           pixel in p. Note that if a single row is given, it will be used
%           for all the pixels.
% Output: I: the image with plotted points.

% Get the number of pixels.
n = size(p, 1);

% Expand c when necessary.
if size(c, 1) == 1
  c = ones(n, 1) * c;
end

% Get the size of the image.
h = size(I, 1);
w = size(I, 2);

% Set the size of the cross.
s = 15;

% Plot each feature point.
for i = 1 : n
  % Loop over all the three channels.
  for j = 1 : 3
    % Clamp it so that it won't be out of bound.
    I(max(p(i, 1) - s, 1) : min(p(i, 1) + s, h), p(i, 2), j) = c(i, j);
    I(p(i, 1), max(p(i, 2) - s, 1) : min(p(i, 2) + s, w), j) = c(i, j);
  end
end

end

