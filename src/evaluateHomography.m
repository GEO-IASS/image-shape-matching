function [ rms, pImage ] = evaluateHomography( M2V, V2P, featureImage, ...
                                               featureVertex )
% Tao Du
% taodu@stanford.edu
% Feb 16, 2015
%
% Given (M2V, V2P), the estimated extrinsic/intrinsic parameters to project
% featureVertex, compute the root-mean-square error between its projected
% 2D points, and featureImage(considered as the groundtruth).
%
% Input: M2V: 4 x 4 matrix.
%        V2P: 3 x 3 matrix.
%        featureImage: n x 2 matrix. Each row is a 2D point in the image
%                      space.
%        featureVertex: n x 3 matrix. Each row is a 3D point from the
%                       shape.
% Output: rms: the root-mean-square error between V2P * M2V * featureVertex
%              and featureImage.
%         pImage: n x 2 matrix. It means the projected featureImage. The
%                 rms is computed based on the difference between
%                 featureImage and pImage.

% Transform featureVertex into camera space.
vCamera = bsxfun(@plus, M2V(1 : 3, 1 : 3) * featureVertex', M2V(1 : 3, 4));

% Project into the image space.
vImage = V2P * vCamera;

% Divide out the last dimension.
vImage = bsxfun(@rdivide, vImage, vImage(end, :));
pImage = vImage(1 : end - 1, :)';

% Compute the rms error.
rms = sqrt(mean(sum((pImage - featureImage).^2, 2)));

end

