function [ R, Q ] = rq( A )
% Tao Du
% taodu@stanford.edu
% Feb 22, 2015
%
% Given a 3 x 3 matrix A, decompose it into a 3 x 3 upper triangular matrix
% R and a 3 x 3 orthogonal matrix Q.
%
% Input: A: 3 x 3 matrix.
% Output: R: 3 x 3 upper triangular matrix.
%         Q: 3 x 3 orthogonal matrix such that R * Q = A.

% Algorithm: Let's start from the old QR factorization:
% B = QR, so B' = R'Q'. Note that R' is lower triangular. To change R' to
% be upper triangular, consider a permutation matrix P:
% P = [0 0 1; 0 1 0; 1 0 0].
% So that (PR'P)(PQ') = PB' becomes the RQ decomposition of PB'.
% To find the RQ decomposition of any matrix A, let's set A = PB', solving
% B gives us B = A'P, and let's do QR decomposition of B.

% Define the permutation matrix P.
P = [0 0 1; 0 1 0; 1 0 0];

% Find B.
B = A' * P;

% QR decomposition of B.
[Q, R] = qr(B);

% Update Q and R.
R = P * R' * P;
Q = P * Q';

end

