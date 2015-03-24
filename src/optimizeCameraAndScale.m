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

% Collect the scaling factor and rms AFTER each iteration. i.e., s(:, 1)
% and rms(1) is the scaling factor and rms error AFTER the first iteration.
% Note that s is initialized as [1, 1, 1]' just for programming reasons,
% and will be removed in the end.
s = ones(3, 1);
rms = [];

% Max iteration number.
maxIter = 1000;
iter = 1;
threshold = 1e-6;

% Be careful about the order in the iterations! Each iteration starts from
% optimizing the camera matrix, then the deform function (the scaling
% function). Once both are updated, we check the condition to decide
% whether we should jump out of the loop.
while iter <= maxIter
  % Optimize M2V and V2P.
  [M2V, V2P] = optimizeCamera(featureImage, featureVertex);
  
  % Optimize scaling factor.
  si = optimizeScale(featureImage, featureVertex, M2V, V2P);

  % Update featureVertex.
  featureVertex = bsxfun(@times, featureVertex, si');

  % Print out the rms error for reference.
  err = evaluateHomography(M2V, V2P, featureImage, featureVertex);
  fprintf('After iteration %d, rms = %f\n', iter, err);
  rms = [rms err];

  % Update scaling factor.
  s = [s s(:, end) .* si];

  % If si = (1.0, 1.0, 1.0). Jump out of the loop.
  if max(abs(si - [1 1 1]')) < threshold
    break;
  end

  % Increment the counter.
  iter = iter + 1;
end

% Remove the first column from s.
s = s(:, 2 : end);

end

