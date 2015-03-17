function [  ] = writeObj2Pbrt( fileName, V, F )
% Tao Du
% taodu@stanford.edu
% Mar 17, 2015
%
% This function writes the vertex and face information into a .pbrt file.
%
% Input: fileName: the name of the .pbrt file.
%        V, F: vertex and face information for the object.

% Open the file.
fid = fopen(fileName, 'w');

% shape property. Note that the indices in PBRT start from 0 not 1.
F = F - 1;
shape = ['AttributeBegin\n', ...
         'Shape "trianglemesh" "point P"\n'];

% Print all the vertices.
vertex = mat2str(V);

% Replace ; with \n.
vertex = strrep(vertex, ';', '\n');
shape = [shape, vertex, '\n', ...
         '"integer indices"\n'];

% Print all fhe faces.
face = mat2str(F);

% Replace ; with \n.
face = strrep(face, ';', '\n');
shape = [shape, face, '\n', ...
         'AttributeEnd\n\n'];
context = [shape 'WorldEnd\n'];

% Write back the context.
fprintf(fid, context);

% Close the file.
fclose(fid);

end

