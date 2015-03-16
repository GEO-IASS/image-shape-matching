function [ s ] = optimizeScale( featureImage, featureVertex, M2V, V2P )
% Tao Du
% taodu@stanford.edu
% Mar 16, 2015
%
% Given correspondence points and transform matrix, estimate the scaling
% factor of featureVertex so that the projection of featureVertex matches
% featureImage.
%
% Input: featureImage: n x 2 matrix.
%        featureVertex: n x 3 matrix.
%        M2V: 4 x 4 matrix. R is the upper left 3 x 3 submatrix, and t is
%             M2V(1 : 3, 4).
%        V2P: a 3 x 3 upper triangular matrix.
% Output: s: a 3 x 1 column vector.

% Get the number of points.
n = size(featureImage, 1);

% Extract K, R and t.
K = V2P;
R = M2V(1 : 3, 1 : 3);
t = M2V(1 : 3, 4);

% Build D.
D = zeros(2 * n, 3);
for i = 1 : n
  % Compute Di.
  Di = K * R * diag(featureVertex(i, :));

  % Extract qi.
  qi = featureImage(i, :);

  % Now fill the values in the i-th and (i + n)-th row in D.
  D(i, :) = Di(1, :) - Di(3, :) * qi(1);
  D(i + n, :) = Di(2, :) - Di(3, :) * qi(2);
end

% Build O.
o = K * t;
O = [featureImage(:, 1) * o(3) - o(1); ...
     featureImage(:, 2) * o(3) - o(2)];

% Solve s.
s = D \ O;

end
