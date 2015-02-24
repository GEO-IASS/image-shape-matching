function [ P, Y ] = normalizePoint( X )
% Tao Du
% taodu@stanford.edu
% Feb 23, 2015
%
% Normalize X such that mean(X) = 0 and the average distance between each
% point to the mean is \sqrt{2}.
%
% Input: X: n x k matrix(k = 2 or 3). Each row is a point.
% Output: P: (k + 1) x (k + 1) matrix.
%         Y: n x k matrix, which satisfies:
%            [Y ones(n, 1)]' = P * [X ones(n, 1)]'.

% Get the dimension of X.
k = size(X, 2);

% Compute the mean of X.
Xmean = mean(X, 1);

% Compute the average distance between mean and each point.
Xdist = mean(sqrt(sum(bsxfun(@minus, X, Xmean).^2, 2)));

% So for each point X, we expect Y = (X - Xmean) * sqrt(2) / Xdist.
Y = bsxfun(@minus, X, Xmean) * sqrt(2) / Xdist;

% Compute the scale factor.
scale = sqrt(2) / Xdist;

% Compute P.
P = [eye(k) * scale -Xmean' * scale; zeros(1, k) 1];

end

