function [ I ] = gammaCorrectImage( I, gamma )
% Tao Du
% taodu@stanford.edu
% Feb 12, 2015

% Do gamma correction for image I.
% Input: I: a height x width x 3 image.
%        gamma: a scalar, typically 2.2.
% Output: I: the corrected height x width x 3 image. The range is (0, 1).

% Use gamma = 2.2 by default.
if nargin == 1
  gamma = 2.2;
end

% Get dimensions of the image.
[~, ~, c] = size(I);

% Get the max value of the image.
maxValue = max(I(:));

% Loop over each channel.
for i = 1 : c
  I(:, :, i) = (I(:, :, i) / maxValue) .^ (1 / gamma); 
end

end

