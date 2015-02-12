function [ V, F ] = readObj( fileName )
% Tao Du
% taodu@stanford.edu
% Feb 11, 2015

% Extract vertices and faces from .obj files.
% Input: fileName: a string representing the file name.
% Output: V: a m x 3 matrix. Each row in V is a vertex.
%         F: a n x 3 matrix. Each row is the indices of the three vertices
%            of a single triangle. Note that the indices in both Matlab and
%            .obj file formats start from 1.
end

