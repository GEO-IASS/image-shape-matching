function [ featurePixel, featureVertex, featureVertexId ] = ...
  selectFeaturePoints( I, V, F )
% Tao Du
% taodu@stanford.edu
% Feb 11, 2015
%
% Select feature points from both images and 3D shapes.
% Input: I: an image.
%        V, F: vertices and faces. Output from readObj.
% Output: featurePixel: n x 2 matrix. Each row is a pixel in I. To visit
%                       the pixel from the i-th feature point, use:
%                       I(featurePixel(i, 1), featurePixel(i, 2)).
%         featureVertex: n x 3 matrix. Each row is a vertex corresponding
%                        to a feature pixel.
%         featureVertexId: n x 1 column vector. It satisfies:
%                          V(featureVertexId, :) = featureVertex.

end

