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

% Initialize p, faceId and bc.
p = [0 0 0]';
faceId = 0;
bc = [0 0 0]';
% T is the parameter in the line: p = o + T * d.
T = inf;

% Loop over all the faces.
for i = 1 : m
  % Extract v1, v2 and v3.
  v = V(F(i, :), :);
  v1 = v(1, :)';
  v2 = v(2, :)';
  v3 = v(3, :)';

  % Compute the normal.
  n = cross(v2 - v1, v3 - v2);
  n = n / norm(n);

  % Determine whether the line is parallel with the plane.
  c = d' * n;
  if abs(c) < 1e-4
    continue;
  end

  % (o + t * d - v1) * n = 0.
  % (o - v1) * n + t * (d * n) = 0.
  % ct + (o - v1) * n = 0.
  t = (o - v1)' * n / -c;
  if t <= 0 || t >= T
    continue;
  end

  % Test whether p is inside the triangle.
  q = o + t * d;
  u1 = v1 - q;
  u2 = v2 - q;
  u3 = v3 - q;
  % Compute the barycentric coordinates.
  w1 = cross(u2, u3)' * n;
  w2 = cross(u3, u1)' * n;
  w3 = cross(u1, u2)' * n;
  
  % Normalization.
  w = w1 + w2 + w3;
  w1 = w1 / w; w2 = w2 / w; w3 = w3 / w;

  % If any w is negative, q is outside the triangle.
  if w1 < 0 || w2 < 0 || w3 < 0
    continue;
  end

  % Finally we find a valid intersection point.
  T = t;
  p = q;
  faceId = i;
  bc = [w1; w2; w3];
end

end

