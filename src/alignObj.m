function [ V ] = alignObj( V )
% Tao Du
% taodu@stanford.edu
% Feb 11, 2015
%
% Given V, set its center at the origin, and rotate it by PCA.
% Input, output: V. n x 3 matrix from readObj.

% Find the center of V.
center = mean(V, 1);
% Shift by center.
V = bsxfun(@minus, V, center);

% Run PCA
[~, V] = pca(V);

end

