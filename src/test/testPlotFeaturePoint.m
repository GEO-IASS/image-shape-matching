% Tao Du
% taodu@stanford.edu
% Feb 16, 2015

% Test plotFeaturePoint.
% clear;
clear all; clc;

% Genrate a black image.
m = 480;
n = 640;
I = zeros(m, n, 3);
imshow(I);

% The number of pixels.
k = 4;

% Call ginput to select k pixels.
p = image2Pixel(ginput2Image(ginput(k)));

% Generate random colors.
c = rand(k, 3);

% Plot the image.
I = plotFeaturePoint(I, p, c);
imshow(I);

%% Test with a single color.
% Call ginput to select k pixels.
p = image2Pixel(ginput2Image(ginput(k)));

% Generate random colors.
c = rand(1, 3);

% Plot the image.
I = plotFeaturePoint(I, p, c);
imshow(I);