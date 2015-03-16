function [ cameraPos ] = getCameraPos( model2View )
% Tao Du
% taodu@stanford.edu
% Mar 8, 2015
%
% Given the 4 x 4 M2V matrix, extract the cameraPos component. This is the
% camera's position in the world coordinates.
%
% Input: model2View: a 4 x 4 matrix.
% Output: cameraPos: a 3 x 1 column vector.

% Get view2Model: a 3 x 3 rotation matrix.
view2Model = model2View(1 : 3, 1 : 3)';

% Compute cameraPos.
cameraPos = view2Model * -model2View(1 : 3, 4);

end

