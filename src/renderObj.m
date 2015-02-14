function [ I, model2View, view2Projection ] = renderObj( V, F, ...
  imageSize, cameraPos, cameraLookAt, cameraUp, fov, lightPos, lightColor )
% Tao Du
% taodu@stanford.edu
% Feb 12, 2015
%
% Given a object (V, F), render it with given camera position and light
% position. It generates a temp folder containg the pbrt script and the
% image, read the image from file, and finally delete the temp folder.
% Input: V, F. Output from readObj.
%        imageSize: a 2 x 1 column vector, width x height.
%        cameraPos: a 3 x 1 column vector. Representing the camera position
%                   in the world coordinates.
%        cameraLookAt: a 3 x 1 column vector. Representing the point our
%                      camera is looking at.
%        cameraUp: a 3 x 1 column vector. Representing the up direction of
%                  our camera. 
%        fov: a scalar in degree.
%        lightPos: a 3 x 1 column vector. Representing a point light in the
%                  world coordinates.
%        lightColor: a 3 x 1 column vector between [0, 1].
% Output: I: a imageSize(1) x imageSize(2) x 3 image.
%         model2View: a 4 x 4 matrix. Given a 3D point p in the model
%                     coordinates, model2View * p gives its coordinates in
%                     the camera coorindates defined by camreaPos,
%                     cameraLookAt and cameraUp.
%         view2Projection: a 3 x 3 matrix. Given a 3D point p in the camera
%                          coordinates, view2Projection * p gives the
%                          homogeneous coordinates in the film plane.

% Define the PBRT root.
PBRT_ROOT = '/home/taodu/research/pbrt-v2/src/bin/pbrt';

% Generate a temp folder.
folderName = ['temp', num2str(randi(512)), '/'];
mkdir(folderName);

%% Build the rendering script.
scriptName = 'rendering.pbrt';
fid = fopen([folderName, scriptName], 'w');

% Initialize the context.
context = '';

% Film property.
film = ['Film "image" "integer xresolution" [', ...
        num2str(imageSize(1)), '] "integer yresolution" [', ...
        num2str(imageSize(2)), ']\n\n'];
context = [context film];

% Camera property.
camera = ['LookAt ', num2str(cameraPos'), ' ', ...
          num2str(cameraLookAt'), ' ', num2str(cameraUp'), '\n'...
          'Camera "perspective" "float fov" [', num2str(fov) ,']\n\n'];
context = [context camera];

% Light property.
light = ['AttributeBegin\n', ...
         'LightSource "point" "point from" ', mat2str(lightPos'), ...
         ' "rgb I" ', mat2str(lightColor'), '\n', ...
         'AttributeEnd\n\n'];
context = [context 'WorldBegin\n\n' light];

% shape property. Note that the indices in PBRT start from 0 not 1.
F = F - 1;
shape = ['AttributeBegin\n', ...
         'Material "matte"\n', ...
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
context = [context shape 'WorldEnd\n'];

% Write back the context.
fprintf(fid, context);
fclose(fid);

%% Call PBRT to render the image.
imageName = 'rendering.exr';
system([PBRT_ROOT, ' --outfile ', folderName, imageName, ' --quiet ', ...
        folderName, scriptName]);

% Read I from the rendering image.
I = exrread([folderName, imageName]);

%% Compute model2View and view2Projection.
% Compute x, y, z of the camera rig.
z = cameraLookAt - cameraPos;
z = z / norm(z);

% Compute x.
x = cross(cameraUp, z);
x = x / norm(x);

% Compute y.
y = cross(z, x);

% Ideally, y should be normalized.
y = y / norm(y);

view2Model = [x y z];

% How we have:
% view2Model * pView + cameraPos = pModel.
% So pView = view2Model' * (pModel - cameraPos)
%          = view2Model' * pModel - view2Model' * cameraPos.
model2View = [view2Model' -view2Model' * cameraPos; 0 0 0 1];

% Compute view2Projection.
if imageSize(1) < imageSize(2)
  angleY = atan(tan(deg2rad(fov / 2)) / imageSize(1) * imageSize(2));
else
  angleY = deg2rad(fov / 2);
end

% The image coordinates:
% The origin is in the top left corner of the image(0, 0).
% x: left to right.
% y: up to down.
% The top right: (w, 0).
% The lower left: (0, h).
% The lower right: (w, h).

% Get width and height.
w = imageSize(1);
h = imageSize(2);

% Compute tangent of angleY.
tanY = tan(angleY);
view2Projection = [h / 2 / tanY, 0, w / 2; 0, -h / 2 / tanY, h / 2; 0 0 1];

%% Delete the temp folder.
rmdir(folderName, 's');

end

