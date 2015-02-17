function [ M2V, V2P ] = optimizeCamera( featureImage, ...
                                        featureVertex, imageSize )
% Tao Du
% taodu@stanford.edu
% Feb 16, 2015
%
% Given a couple of 2D vertices, and its 2D projections, estimate the
% intrinsic and extrinsic parameters of the camera. Here we assume a
% perspective camera model.
%
% Input: featureImage: n x 2 matrix.
%        featureVertex: n x 3 matrix.
%        imageSize: a 2 x 1 vector. [width, height]'.
% Output: M2V: a 4 x 4 matrix.
%         V2P: a 3 x 3 upper triangular matrix.

% The projection function.
% Input: f: a parameter in V2P.
%        R, T: rotation and translation parameters. R is a SO(3) matrix and
%              T is a 3 x 1 column vector.
%        p: a n x 3 matrix. Each row is a point in 3D space.
%        q: a n x 2 matrix. Each row is a pixel in image space.
%        h, w: both are scalars. The height and width of the image.
function [ res ] = projection( f, R, T, p, q, h, w )
  view2Projection = [f * h / 2, 0, w / 2; 0, -f * h / 2, h / 2; 0 0 1];
  M = view2Projection * [R T];

  % Augment p, then project into image space.
  p2 = M * [p ones(size(p, 1), 1)]';

  % Divide out the last dimenison.
  p2 = bsxfun(@rdivide, p2, p2(end, :));
  p2 = p2(1 : end - 1, :);

  % Compute the residual.
  res = sum(sum((p2 - q').^2));
end

% Encode the rotation constraint: R' * R = I.
% Input: x: a 13 x 1 column vector. x(2 : 10) is the rotation matrix.
% Output: c: []
%         ceq: a 9 x 1 column vector encoding the equality constraint.
function [ c, ceq ] = rotationConstraint( x )
  c = [];
  R = reshape(x(2 : 10), 3, 3);
  res = R' * R - eye(3);
  ceq = res(:);
end

% Set the lower bound: f > 0
lb = -inf(13, 1);
lb(1) = 1e-4;
x = fmincon(@(x) projection(x(1), reshape(x(2 : 10), 3, 3), x(11 : 13), ...
            featureVertex, featureImage, imageSize(2), imageSize(1)), ...
            [10; 1; 0; 0; 0; 1; 0; 0; 0; 1; 10; 10; 10], ... % x0.
            [], [], [], [], ... % Linear constraints.
            lb, [], ... % Bounds.
            @(x) rotationConstraint(x)); % Nonlinear constraints.

% Decode the solution.
f = x(1);
w = imageSize(1);
h = imageSize(2);
V2P = [f * h / 2, 0, w / 2; 0, -f * h / 2, h / 2; 0 0 1];

% Rotation matrix and translation vector.
rotation = reshape(x(2 : 10), 3, 3);
translation = x(11 : 13);
M2V = [rotation translation; 0 0 0 1];

end

