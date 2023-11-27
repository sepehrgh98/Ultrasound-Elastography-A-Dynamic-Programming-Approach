clc;
clear;
close all;


load('..\Results\DP_1D\DisplacementMap1D.mat');
load('..\Results\DP_1D\DisplacementMapMedian1D.mat');

figure;imagesc(displacementMap); colormap hot; colorbar; title('Axial Displacement');
figure;imagesc(displacementMap_median); colormap hot; colorbar; title('Axial Displacement Median');



disp 'Calculating 1D DP Strain ...';
wDIff = 43; % window length of the differentiation kernel
[strain1] = LSQ(displacementMap,wDIff);
[median_strain1] = LSQ(displacementMap_median,wDIff);

strain1 = strain1((wDIff+1)/2:end-(wDIff-1)/2,:);

strain1(strain1>-2e-2) = -2e-2;
strain1(strain1<-.1) = -.1;

startA = 1; endA = size(strain1,2);
startRF = 100; endRF = size(strain1,1); 
figure; imagesc(-strain1(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('1D Elastography')


% figure;imagesc(strain1); colormap hot; colorbar; title('Strain 1D DP');
% figure;imagesc(median_strain1); colormap hot; colorbar; title('Strain 1D DP Median');

% disp 'Saving Results....';
% save('..\Results\DP_1D\Strain1D.mat', 'strain2');
% save('..\Results\DP_1D\StrainMedian1D.mat', 'median_strain2');
% 
% disp 'Results have been saved!';
% 
% disp 'The unitless performance metric Calculation ...!';
% 
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
