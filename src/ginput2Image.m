function [ P ] = ginput2Image( P )
% Tao Du
% taodu@stanford.edu
% Feb 13, 2015

% Compute the center of the pixels selected by ginput, in image
% coordinates.

% Input: P: a n x 2 matrix. The direct output of ginput.
% Outut: P: a n x 2 matrix.

% Convert P into pixel coordinates first.
P = floor(P - 0.5) + 1;

% Compute its center in image coordinates.
P = P - 0.5;

end

