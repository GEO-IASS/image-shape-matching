function [ p, faceId, bc ] = intersectP( V, F, o, d )
% Tao Du
% taodu@stanford.edu
% Feb 14, 2015
%
% Given a shape (V, F) and a ray defined as l(t) = o + t * d, compute the
% intersection points. If no valid intersection point is found, return p =
% [0 0 0]', faceId = 0, bc = [0 0 0]'.
%
% Input: (V, F): output of readObj.
%        o, d: both are 3 x 1 column vectors representing a line o + t * d.
% Output: p: the intersection point.
%         faceId: F(faceId, :) is the triangle where p lies in.
%         bc: the barycentric coordinates of p in F(faceId, :).

% Get the number of faces.
m = size(F, 1);

% Normalize d.
d = d / norm(d);

% Extract vertices.
V1 = V(F(:, 1), :)';
V2 = V(F(:, 2), :)';
V3 = V(F(:, 3), :)';

% Compute the normal for each triangle.
N = cross(V2 - V1, V3 - V2);
N = bsxfun(@rdivide, N, sqrt(dot(N, N, 1)));

% If C is almost zero, then the line and the plane are parallel.
C = d' * N;

% (o + t * d - v1) * n = 0.
% (o - v1) * n + t * (d * n) = 0.
% ct + (o - v1) * n = 0.
T = bsxfun(@rdivide, dot(bsxfun(@minus, o, V1), N, 1), -C);

Q = bsxfun(@plus, o, bsxfun(@times, T, d));
U1 = V1 - Q;
U2 = V2 - Q;
U3 = V3 - Q;

% Compute the barycentric coordinates.
W1 = dot(cross(U2, U3), N, 1);
W2 = dot(cross(U3, U1), N, 1);
W3 = dot(cross(U1, U2), N, 1);

% Normalization.
W = W1 + W2 + W3;
W1 = W1 ./ W;
W2 = W2 ./ W;
W3 = W3 ./ W;

% If the line and the plane are parallel, or T is negative, or T is
% positive but any of W1, W2, W3 is negative, set T to be inf.
T(abs(C) < 1e-4 | T < 0 | W1 < 0 | W2 < 0 | W3 < 0) = inf;

% Now the min T is the solution.
[t, faceId] = min(T);
if isinf(t)
  p = [0 0 0]';
  faceId = 0;
  bc = [0 0 0]';
else
  p = o + t * d;
  bc = [W1(faceId); W2(faceId); W3(faceId)];
end

end

