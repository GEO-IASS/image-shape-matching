function [ M2V, V2P ] = optimizeCamera( featureImage, featureVertex )
% Tao Du
% taodu@stanford.edu
% Feb 21, 2015
%
% Given a couple of 2D vertices, and its 2D projections, estimate the
% intrinsic and extrinsic parameters of the camera. Here we assume a
% perspective camera model.
%
% Input: featureImage: n x 2 matrix.
%        featureVertex: n x 3 matrix.
% Output: M2V: a 4 x 4 matrix.
%         V2P: a 3 x 3 upper triangular matrix.

% We first estimate a 3 x 4 homogeneous matrix M up to scale, then we
% decode K and R t from M:
% M = K[R t] = [KR Kt], here R is orthogonal rotation matrix, t is a
% translation vector. K is a 3 x 3 upper triangular matrix.
% Note that V2P = K, M2V = [R t; 0 0 0 1].

% Estimate M.
% Define X = [X1, X2, X3, 1] to be the homogeneous coordinates from
% featureVertex, and x = [x1, x2] to be the corresponding pixels, we have:
% x1' = m11 X1 + m12 X2 + m13 X3 + m14
% x2' = m21 X1 + m22 X2 + m23 X3 + m24
% x3' = m31 X1 + m32 X2 + m33 X3 + m34
% x1' / x3' = x1, x2' / x3' = x2 =>
% x1' = x1 * x3', x2' = x2 * x3' =>
% m11 X1 + m12 X2 + m13 X3 + m14 - x1 * (m31 X1 + m32 X2 + m33 X3 + m34) = 0
% m21 X1 + m22 X2 + m23 X3 + m24 - x2 * (m31 X1 + m32 X2 + m33 X3 + m34) = 0
% M can be solved by Am = 0, which can further be solved by SVD.

% Get the dimension of points.
n = size(featureVertex, 1);

% Rename featureVertex and featureImage for simplicity.
Y = featureVertex;
y = featureImage;

% If we use Y and y to solve M directly, we will see M is ill-conditioned.
% To resolve the problem, we first shift and scale Y such that mean(Y) = 0,
% and the average distance between each point and its mean is \sqrt{2}, and
% do it similarly for y.
% More concretely, we define X = PY and x = Qy, then solve x = NX, i.e.,
% Qy = NPY. So M = Q^{-1}NP.
[P, X] = normalizePoint(Y);
[Q, x] = normalizePoint(y);

% Augment X by 1 for simplicity.
X = [X ones(n, 1)];

% Build A from the equations above.
A = [blkdiag(X, X) bsxfun(@times, -x(:), [X; X])];

% Using SVD to solve m.
[~, ~, V] = svd(A);
m = V(:, end);
M = reshape(m, 4, 3)';

% Now absorb P and Q into M.
M = Q \ (M * P);

%% Extract K, R, t from M.
% M = [KR, Kt]. We need to decompose M(:, 1 : 3) as the product of an upper
% triangular matrix K and an orthogonal matrix R.
% Initialize m1 to m4 first.
m1 = M(:, 1); m2 = M(:, 2); m3 = M(:, 3); m4 = M(:, 4);

% Build v12, v13, v23, v11, v22, v33. All of them are column vectors.
v12 = [m1(1) * m2(1) + m1(2) * m2(2); m1(1) * m2(3) + m1(3) * m2(1); ...
       m1(2) * m2(3) + m1(3) * m2(2); m1(3) * m2(3)];
v13 = [m1(1) * m3(1) + m1(2) * m3(2); m1(1) * m3(3) + m1(3) * m3(1); ...
       m1(2) * m3(3) + m1(3) * m3(2); m1(3) * m3(3)];
v23 = [m2(1) * m3(1) + m2(2) * m3(2); m2(1) * m3(3) + m2(3) * m3(1); ...
       m2(2) * m3(3) + m2(3) * m3(2); m2(3) * m3(3)];
v11 = [m1(1) * m1(1) + m1(2) * m1(2); m1(1) * m1(3) + m1(3) * m1(1); ...
       m1(2) * m1(3) + m1(3) * m1(2); m1(3) * m1(3)];
v22 = [m2(1) * m2(1) + m2(2) * m2(2); m2(1) * m2(3) + m2(3) * m2(1); ...
       m2(2) * m2(3) + m2(3) * m2(2); m2(3) * m2(3)];
v33 = [m3(1) * m3(1) + m3(2) * m3(2); m3(1) * m3(3) + m3(3) * m3(1); ...
       m3(2) * m3(3) + m3(3) * m3(2); m3(3) * m3(3)];

% Build V.
V = [v12'; v13'; v23'; (v11 - v22)'; (v22 - v33)'];

% Solve b.
[~, ~, b] = svd(V);
b = b(:, end);

% Now solve K.
x = -b(2) / b(1);
y = -b(3) / b(1);
beta = b(4) - (b(2) * b(2) + b(3) * b(3)) / b(1);
f = sqrt(beta / b(1));
K = [f 0 x; 0 f y; 0 0 1];

% Solve R and t.
R = K \ [m1 m2 m3];
t = K \ m4;

% Enforce R is orthogonal. Note that the scaling factor should be divided
% from both R and t.
[u, ~, v] = svd(R);
lambda = norm(R, 'fro') / norm(u * v', 'fro');
R = u * v';
t = t / lambda;

% Since we know K(1, 1) is positive and K(2, 2) is negative, we flip the
% signs for K(:, 1) and K(:, 2), and, as well as R(1, :), t(1), R(2, :),
% t(2) if necessary.
% Do we need to multiply -1 for the first column?
if K(1, 1) < 0
  K(:, 1) = -K(:, 1);
  R(1, :) = -R(1, :);
  t(1) = -t(1);
end
% Do we need to flip the sign for the second column?
if K(2, 2) > 0
  K(:, 2) = -K(:, 2);
  R(2, :) = -R(2, :);
  t(2) = -t(2);
end

% Fill in the return value.
M2V = [R t; 0 0 0 1];
V2P = K;

end

