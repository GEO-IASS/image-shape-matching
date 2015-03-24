% Tao Du
% taodu@stanford.edu
% Mar 23, 2015

% Clear.
clear all; clc; close all;
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Please comment out optimizeCameraAndScale in the function as we do not
% handle exceptions!

% Initialization. Modify here when necessary.
modelName = 'aeroplane';
imagesetName = 'imagenet';
fileName = 'n02690373_101';
load([PASCAL_ROOT, 'Annotations/aeroplane_imagenet/n02690373_101.mat']);
cadId = record.objects(1).cad_index;
% End of Initialization.

[I, V, F, featureImage, featureVertex] = ...
    optimizePascalExample(modelName, imagesetName, fileName);

% Test the image.
figure;
imshow(I);

% Test the model.
figure;
trimesh(F, V(:, 1), V(:, 2), V(:, 3));

% Compare featureImage.
fprintf('featureImage = \n');
disp(featureImage);

disp(record.objects(1).anchors.left_elevator);
disp(record.objects(1).anchors.left_wing);
disp(record.objects(1).anchors.noselanding);
disp(record.objects(1).anchors.right_elevator);
disp(record.objects(1).anchors.right_wing);
disp(record.objects(1).anchors.rudder_lower);
disp(record.objects(1).anchors.rudder_upper);
disp(record.objects(1).anchors.tail);

% Compare featureVertex.
fprintf('featureVertex = \n');
disp(featureVertex);
load([PASCAL_ROOT, 'CAD/aeroplane.mat']);

disp(aeroplane(cadId).left_elevator);
disp(aeroplane(cadId).left_wing);
disp(aeroplane(cadId).noselanding);
disp(aeroplane(cadId).right_elevator);
disp(aeroplane(cadId).right_wing);
disp(aeroplane(cadId).rudder_lower);
disp(aeroplane(cadId).rudder_upper);
disp(aeroplane(cadId).tail);