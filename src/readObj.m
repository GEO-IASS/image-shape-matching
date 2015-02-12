function [ V, F ] = readObj( fileName )
% Tao Du
% taodu@stanford.edu
% Feb 11, 2015

% Extract vertices and faces from .obj files. Assume the file format is:
% All the vertices:
% v 1 2 3
% v 4 5 6
% ...
% Then all the faces:
% f 1 3 2
% f 1 4 5
% ...
% The file is allowed to contain some comments.
% Input: fileName: a string representing the file name.
% Output: V: a m x 3 matrix. Each row in V is a vertex.
%         F: a n x 3 matrix. Each row is the indices of the three vertices
%            of a single triangle. Note that the indices in both Matlab and
%            .obj file formats start from 1.

% Open up files.
fid = fopen(fileName);

% Initialize V and F.
V = [];
F = [];

% Read files line by line.
line = fgetl(fid);
while ischar(line)
  % If line starts with '#', skip it.
  if isempty(line) || line(1) == '#'
    line = fgetl(fid);
    continue;
  end

  % Read vertices and faces.
  if line(1) == 'v'
    [v1, v2, v3] = strread(line(2 : end), '%f%f%f');
    V = [V; v1 v2 v3];
  elseif line(1) == 'f'
    [f1, f2, f3] = strread(line(2 : end), '%d%d%d');
    F = [F; f1 f2 f3];
  end

  % Read new lines.
  line = fgetl(fid);
end

% Close the file.
fclose(fid);
end

