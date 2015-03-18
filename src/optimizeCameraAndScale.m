function [ M2V, V2P, s, rms ] = ...
  optimizeCameraAndScale( featureImage, featureVertex )
% Tao Du
% taodu@stanford.edu
% Mar 16, 2015
%
% Given featureImage and featureVertex, estimate the camera matrix K, R, t
% and the scaling factor s. The algorithm alternates between [M2V, V2P] and
% s, until they converge.
%
% Input: featureImage: n x 2 matrix.
%        featureVertex: n x 3 matrix.
% Output: M2V: 4 x 4 matrix.
%         V2P: 3 x 3 matrix.
%         s: 3 x iter column vector, each column is the scaling factor
%            after each iteration. 
%         rms: 1 x iter row vector.

% Initialize the scaling factor.
s = ones(3, 1);

% Max iteration number.
maxIter = 1000;
iter = 0;
threshold = 1e-6;

rms = [];
while iter < maxIter
  % Optimize M2V and V2P.
  [M2V, V2P] = optimizeCamera(featureImage, featureVertex);
  
  % Optimize scaling factor.
  si = optimizeScale(featureImage, featureVertex, M2V, V2P);

  % If si = (1.0, 1.0, 1.0). Jump out of the loop.
  if max(abs(si - [1 1 1]')) < threshold
    break;
  end

  % Update featureVertex.
  featureVertex = bsxfun(@times, featureVertex, si');

  % Print out the rms error for reference.
  err = evaluateHomography(M2V, V2P, featureImage, featureVertex);
  fprintf('iter = %d, rms = %f\n', iter, err);
  rms = [rms err];

  % Update scaling factor.
  s = [s s(:, end) .* si];

  % Increment the counter.
  iter = iter + 1;
end

% Remove the first column from s.
s = s(:, 2 : end);

end

