% Tao Du
% taodu@stanford.edu
% Mar 21, 2015

% We hard coded all the keypoint names for the models in Beyond PASCAL (See
% README for more details), this script tests whether we made mistakes like
% silly typos!

% Clear.
clear all; clc; close all;

% Initialize the root path.
PROJECT_ROOT = '/home/taodu/research/image-shape-matching/';
PASCAL_ROOT = '/home/taodu/research/pascal/';

% Initialize the class names.
classNum = 12;
classNames = cell(classNum, 1);
classNames{1} = 'aeroplane';
classNames{2} = 'bicycle';
classNames{3} = 'boat';
classNames{4} = 'bottle';
classNames{5} = 'bus';
classNames{6} = 'car';
classNames{7} = 'chair';
classNames{8} = 'diningtable';
classNames{9} = 'motorbike';
classNames{10} = 'sofa';
classNames{11} = 'train';
classNames{12} = 'tvmonitor';

% Loop over all the classes.
passTest = 1;
for i = 1 : classNum
  % Load the keypoint names.
  load([PROJECT_ROOT, 'data/pascal/', classNames{i}, '.mat']);

  % Load the corresponding CAD model.
  load([PASCAL_ROOT, 'CAD/', classNames{i}, '.mat']);

  % Visit all the keypoint names.
  keypointNum = length(keypointNames);
  for j = 1 : keypointNum
    % Does it contain a field className{i}.keypointNames{j}?
    if eval(['isfield(', classNames{i}, ',', ...
             '''', keypointNames{j}, '''', ')']) == 0
      fprintf('Error! No field %s in %s!\n', ...
              keypointNames{j}, classNames{i});
      passTest = 0;
    end
  end
end

if passTest == 1
  % Passed all the tests!
  fprintf('Passed all the tests!\n');
end