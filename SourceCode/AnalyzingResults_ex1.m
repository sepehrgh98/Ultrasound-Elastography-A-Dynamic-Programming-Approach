clc;
clear;
close all;

% ###################################################################
% ############################# ex1 #################################
% ###################################################################

% Load data
load('..\Results\ex1\DP_1D\DisplacementMap1D.mat');
load('..\Results\ex1\DP_1D\DisplacementMapMedian1D.mat');

load('..\Results\ex1\DP_2D\AxialDisplacementMap2D.mat');
load('..\Results\ex1\DP_2D\AxialDisplacementMapMedian2D.mat');

figure;imagesc(displacementMap); colormap hot; colorbar; title('Axial Displacement 1D');
figure;imagesc(displacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 1D');

figure;imagesc(axialDisplacementMap); colormap hot; colorbar; title('Axial Displacement 2D');
figure;imagesc(axialDisplacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 2D');

disp 'Calculating 1D DP Strain ...';

% 1D DP
wDIff = 43; % window length of the differentiation kernel
[strain1D] = LSQ(displacementMap,wDIff);

strain1D = strain1D((wDIff+1)/2:end-(wDIff-1)/2,:);

strain1D(strain1D>-2e-2) = -2e-2;
strain1D(strain1D<-.1) = -.1;

startA = 1; endA = size(strain1D,2);
startRF = 100; endRF = size(strain1D,1); 
figure; imagesc(-strain1D(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('1D Elastography')

[median_strain1D] = LSQ(displacementMap_median,wDIff);
median_strain1D = median_strain1D((wDIff+1)/2:end-(wDIff-1)/2,:);

median_strain1D(median_strain1D>-2e-2) = -2e-2;
median_strain1D(median_strain1D<-.1) = -.1;

startA = 1; endA = size(median_strain1D,2);
startRF = 100; endRF = size(median_strain1D,1); 
figure; imagesc(-median_strain1D(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('1D Elastography Median')

% 2D DP

disp 'Calculating 2D DP Strain ...';

wDIff = 43; % window length of the differentiation kernel
[strain2D] = LSQ(axialDisplacementMap,wDIff);

strain2D = strain2D((wDIff+1)/2:end-(wDIff-1)/2,:);

strain2D(strain2D>-2e-2) = -2e-2;
strain2D(strain2D<-.1) = -.1;

startA = 1; endA = size(strain2D,2);
startRF = 100; endRF = size(strain2D,1); 
figure; imagesc(-strain2D(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('2D Elastography')

[median_strain2D] = LSQ(axialDisplacementMap_median,wDIff);

median_strain2D = median_strain2D((wDIff+1)/2:end-(wDIff-1)/2,:);

median_strain2D(median_strain2D>-2e-2) = -2e-2;
median_strain2D(median_strain2D<-.1) = -.1;

startA = 1; endA = size(median_strain2D,2);
startRF = 100; endRF = size(median_strain2D,1); 
figure; imagesc(-median_strain2D(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('2D Elastography Median')

% Save Results
disp 'Saving Results....';
save('..\Results\ex1\DP_1D\Strain1D.mat', 'strain1D');
save('..\Results\ex1\DP_1D\StrainMedian1D.mat', 'median_strain1D');
save('..\Results\ex1\DP_2D\Strain2D.mat', 'strain2D');
save('..\Results\ex1\DP_2D\StrainMedian2D.mat', 'median_strain2D');

disp 'Results have been saved!';

disp 'The unitless performance metric Calculation ...!';

% % CNR
% 
% targetWindowFirstPoint = [900, 220];  
% targetWindowLastPoint = [1100, 260]; 
% 
% marginSize = 5;  % in pixel
% M = 10;  % Replace with your desired number of background windows
% 
% DP1D_CNR = CNR(strain2, targetWindowFirstPoint, targetWindowLastPoint, marginSize, M);
% 
% 
% % SNR


