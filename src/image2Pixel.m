function [ P ] = image2Pixel( P )
% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Given pixels in the image space, clamp into pixel space. See README for
% more explanation about these coordinates. Assume i and j are integeres.
% then all the points lie in [i, i + 1) x [j, j + 1) are covered in the
% pixel (j + 1, i + 1).

% Input: P: a n x 2 matrix represents the points in the image coordinates.
% Output: P: a n x 2 matrix represents the pixels each point belongs to.

I = floor(P(:, 1));
J = floor(P(:, 2));
P = [J + 1 I + 1];

end

