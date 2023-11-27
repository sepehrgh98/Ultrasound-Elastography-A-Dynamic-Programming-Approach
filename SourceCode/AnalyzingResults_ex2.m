clc;
clear;

% ###################################################################
% ############################# ex2 #################################
% ###################################################################

% Load data
load('..\Results\ex2\DP_1D\DisplacementMap1D_ex2.mat');
load('..\Results\ex2\DP_1D\DisplacementMapMedian1D_ex2.mat');

load('..\Results\ex2\DP_2D\AxialDisplacementMap2D_ex2.mat');
load('..\Results\ex2\DP_2D\AxialDisplacementMapMedian2D_ex2.mat');

figure;imagesc(displacementMap); colormap hot; colorbar; title('Axial Displacement 1D');
figure;imagesc(displacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 1D');

figure;imagesc(axialDisplacementMap); colormap hot; colorbar; title('Axial Displacement 2D');
figure;imagesc(axialDisplacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 2D');

disp 'Calculating 1D DP Strain ...';

% 1D DP
wDIff = 43;
[strain1D_ex2] = LSQ(displacementMap,wDIff);

strain1D_ex2 = strain1D_ex2((wDIff+1)/2:end-(wDIff-1)/2,:);

startA = 1; endA = size(strain1D_ex2,2);
startRF = 100; endRF = size(strain1D_ex2,1); 
figure; imagesc(-strain1D_ex2(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('Elastography')


[median_strain1D_ex2] = LSQ(displacementMap_median,wDIff);

median_strain1D_ex2 = median_strain1D_ex2((wDIff+1)/2:end-(wDIff-1)/2,:);

startA = 1; endA = size(median_strain1D_ex2,2);
startRF = 100; endRF = size(median_strain1D_ex2,1); 
figure; imagesc(-median_strain1D_ex2(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('Elastography Median')

% 2D DP

disp 'Calculating 2D DP Strain ...';

wDIff = 43; % window length of the differentiation kernel
[strain2D_ex2] = LSQ(axialDisplacementMap,wDIff);

strain2D_ex2 = strain2D_ex2((wDIff+1)/2:end-(wDIff-1)/2,:);

startA = 1; endA = size(strain2D_ex2,2);
startRF = 100; endRF = size(strain2D_ex2,1); 
figure; imagesc(-strain2D_ex2(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('2D Elastography')

[median_strain2D_ex2] = LSQ(axialDisplacementMap_median,wDIff);
median_strain2D_ex2 = median_strain2D_ex2((wDIff+1)/2:end-(wDIff-1)/2,:);

median_strain2D_ex2(median_strain2D_ex2>-2e-2) = -2e-2;
median_strain2D_ex2(median_strain2D_ex2<-.1) = -.1;

startA = 1; endA = size(median_strain2D_ex2,2);
startRF = 100; endRF = size(median_strain2D_ex2,1); 
figure; imagesc(-median_strain2D_ex2(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('2D Elastography Median')


% Save Results
disp 'Saving Results....';
save('..\Results\ex2\DP_1D\Strain1D_ex2.mat', 'strain1D_ex2');
save('..\Results\ex2\DP_1D\StrainMedian1D_ex2.mat', 'median_strain1D_ex2');
save('..\Results\ex2\DP_2D\Strain2D_ex2.mat', 'strain2D_ex2');
save('..\Results\ex2\DP_2D\StrainMedian2D_ex2.mat', 'median_strain2D_ex2');


disp 'Results have been saved!';