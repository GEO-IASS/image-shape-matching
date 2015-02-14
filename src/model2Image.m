function [ P ] = model2Image( V, model2View, view2Projection )
% Tao Du
% taodu@stanford.edu
% Feb 13, 2015
%
% Given vertices in the model space, as well as transform matrices, compute
% the image coordinates.
%
% Input: V: a n x 3 matrix. The output of readObj.
%        model2View, view2Projection: transformation matrices. The output
%                                     of renderObj.
% Output: P: a n x 2 matrix. Each row is the corresponding pixels for each
%            vertex in V.

% Extract R and T from transformation.
R = model2View(1 : 3, 1 : 3);
T = model2View(1 : 3, 4);

% Combine model2View and view2Projection together.
R = view2Projection * R;
T = view2Projection * T;

% Transpose V first.
V = V';
P = bsxfun(@plus, R * V, T);

% Divide by the last coordinates.
P = bsxfun(@rdivide, P, P(end, :));
P = P(1 : end - 1, :)';
end

