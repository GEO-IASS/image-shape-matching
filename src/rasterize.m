function [ I ] = rasterize( V, F, M2V, V2P, imageSize )
% Tao Du
% taodu@stanford.edu
% Feb 23, 2015
%
% Given a 3D shape (V, F), transformation (M2V, V2P), and the image size
% imageSize, returns an indicator matrix I, where each pixel indicates it
% is covered by at least one triangle.
%
% Input: V, F: see readObj.
%        M2V, V2P: see model2View and view2Projection in renderObj.
%        imageSize: 2 x 1 column vector. w x h.
% Output: I: a h x w image. I(i, j) = 1 means this pixel is covered by a
%            triangle in (V, F), and 0 otherwise.

% Extract w and h.
w = imageSize(1);
h = imageSize(2);

% Initialize I.
I = zeros(h, w);

% Transform V into camera space.
vCamera = bsxfun(@plus, M2V(1 : 3, 1 : 3) * V', M2V(1 : 3, 4));

% Project into the image space.
vImage = V2P * vCamera;

% Divide out the last dimension.
vImage = bsxfun(@rdivide, vImage, vImage(end, :));
vImage = vImage(1 : end - 1, :)';

% Loop over all the triangles.
n = size(F, 1);
for i = 1 : n
  % Get the three points of the triangle in the image space. Here p is a 3
  % x 2 matrix.
  p = vImage(F(i, :), :);
  % Concatenate the first point to the last so that it forms a loop.
  p = [p; p(1, :)];

  % Compute the bounding box of p1, p2, p3 in the pixel space. We also
  % clamp the results so that it is within the image.
  hmin = max(floor(min(p(:, 2))) + 1, 1);
  hmax = min(floor(max(p(:, 2))) + 1, h);
  wmin = max(floor(min(p(:, 1))) + 1, 1);
  wmax = min(floor(max(p(:, 1))) + 1, w);

  % If hmax < hmin or wmax < wmin, the bounding box does not intersect with
  % the image.
  if hmax < hmin || wmax < wmin
    continue;
  end

  % So now I(hmin : hmax, wmin : wmax) safely covers the triangle.
  % Generate the center of the pixels.
  [X, Y] = meshgrid(wmin : wmax, hmin : hmax);
  X = X - 0.5; Y = Y - 0.5;
  
  % Now X and Y represents the centers of all the pixels in the bounding
  % box. Use inpolygon to decide whether this pixels are in the triangle.
  Imap = inpolygon(X, Y, p(:, 1), p(:, 2));
  
  % Update I.
  I(hmin : hmax, wmin : wmax) = I(hmin : hmax, wmin : wmax) | Imap;
end

end

