function [ V ] = image2Model( P, model2View, view2Projection )
% Tao Du
% taodu@stanford.edu
% Feb 13, 2015
%
% Given points in the image coordinates, as well as transform matrices,
% convert it back to the model(world) coordinates. Consider it as the
% inverse of model2Image.
%
% Input: P: n x 2 matrix.
%        model2View, view2Projection: transform matrices from renderObj.
% Output: V: n x 3 matrix.

% Homogeneous P.
P = [P ones(size(P, 1), 1)]';

% Extract R and T from transformation.
R = model2View(1 : 3, 1 : 3);
T = model2View(1 : 3, 4);

% Combine model2View and view2Projection together.
T = view2Projection * T;

V = R' * (view2Projection \ bsxfun(@minus, P, T));

% Transpose V back.
V = V';
end

