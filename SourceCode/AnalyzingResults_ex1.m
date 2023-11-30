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

% figure;imagesc(displacementMap); colormap hot; colorbar; title('Axial Displacement 1D');
% figure;imagesc(displacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 1D');
% 
% figure;imagesc(axialDisplacementMap); colormap hot; colorbar; title('Axial Displacement 2D');
% figure;imagesc(axialDisplacementMap_median); colormap hot; colorbar; title('Axial Displacement Median 2D');

disp 'Calculating 1D DP Strain ...';

% 1D DP
wDIff = 73; % window length of the differentiation kernel
[strain1D] = LSQ(displacementMap,wDIff);

strain1D = strain1D((wDIff+1)/2:end-(wDIff-1)/2,:);

strain1D(strain1D>-2e-2) = -2e-2;
strain1D(strain1D<-.1) = -.1;

startA = 1; endA = size(strain1D,2);
startRF = 100; endRF = size(strain1D,1); 
strain1D = -strain1D(startRF:endRF, startA:endA);
% figure; imagesc(strain1D);
% colorbar; colormap(gray); title('1D Elastography')

[median_strain1D] = LSQ(displacementMap_median,wDIff);
median_strain1D = median_strain1D((wDIff+1)/2:end-(wDIff-1)/2,:);

median_strain1D(median_strain1D>-2e-2) = -2e-2;
median_strain1D(median_strain1D<-.1) = -.1;

startA = 1; endA = size(median_strain1D,2);
startRF = 100; endRF = size(median_strain1D,1); 
median_strain1D = -median_strain1D(startRF:endRF, startA:endA);
% figure; imagesc(median_strain1D);
% colorbar; colormap(gray); title('1D Elastography Median')

% 2D DP

disp 'Calculating 2D DP Strain ...';

wDIff = 73; % window length of the differentiation kernel
[strain2D] = LSQ(axialDisplacementMap,wDIff);




strain2D = strain2D((wDIff+1)/2:end-(wDIff-1)/2,:);


strain2D(strain2D>-2e-2) = -2e-2;
strain2D(strain2D<-.1) = -.1;


startA = 1; endA = size(strain2D,2);
startRF = 100; endRF = size(strain2D,1); 

strain2D = -strain2D(startRF:endRF, startA:endA);

figure; imagesc(strain2D);
colorbar; colormap(gray); title('2D Elastography')

[median_strain2D] = LSQ(axialDisplacementMap_median,wDIff);

median_strain2D = median_strain2D((wDIff+1)/2:end-(wDIff-1)/2,:);

median_strain2D(median_strain2D>-2e-2) = -2e-2;
median_strain2D(median_strain2D<-.1) = -.1;

startA = 1; endA = size(median_strain2D,2);
startRF = 100; endRF = size(median_strain2D,1);

median_strain2D = -median_strain2D(startRF:endRF, startA:endA);
% figure; imagesc(median_strain2D);
% colorbar; colormap(gray); title('2D Elastography Median')

% Save Results
disp 'Saving Results....';
save('..\Results\ex1\DP_1D\Strain1D.mat', 'strain1D');
save('..\Results\ex1\DP_1D\StrainMedian1D.mat', 'median_strain1D');
save('..\Results\ex1\DP_2D\Strain2D.mat', 'strain2D');
save('..\Results\ex1\DP_2D\StrainMedian2D.mat', 'median_strain2D');

disp 'Results have been saved!';

disp 'The unitless performance metric Calculation ...!';


% surf(strain2D)
% shading interp  % or shading faceted
% light
% lighting gouraud  % or lighting flat



% CNR
targetWindowFirstPoint = [670, 210];  
targetWindowLastPoint = [970, 290]; 

DP1D_CNR = CNR(strain1D, targetWindowFirstPoint, targetWindowLastPoint);
DP1D_CNR_MEDIAN = CNR(median_strain1D, targetWindowFirstPoint, targetWindowLastPoint);
DP2D_CNR = CNR(strain2D, targetWindowFirstPoint, targetWindowLastPoint);
DP2D_CNR_MEDIAN = CNR(median_strain2D, targetWindowFirstPoint, targetWindowLastPoint);


DP1D_CNR = DP1D_CNR(:);
DP1D_CNR_MEDIAN = DP1D_CNR_MEDIAN(:);
DP2D_CNR = DP2D_CNR(:);
DP2D_CNR_MEDIAN = DP2D_CNR_MEDIAN(:);

DP1D_CNR_MEAN  = mean(DP1D_CNR);
DP1D_CNR_MEDIAN_MEAN = mean(DP1D_CNR_MEDIAN);
DP2D_CNR_MEAN = mean(DP2D_CNR);
DP2D_CNR_MEDIAN_MEAN = mean(DP2D_CNR_MEDIAN);

DP1D_CNR_MEAN  
DP1D_CNR_MEDIAN_MEAN
DP2D_CNR_MEAN
DP2D_CNR_MEDIAN_MEAN
% Find the overall minimum and maximum values for bin edges
minValue = min([min(DP1D_CNR),min(DP1D_CNR_MEDIAN), min(DP2D_CNR),min(DP2D_CNR_MEDIAN)]);
maxValue = max([max(DP1D_CNR),max(DP1D_CNR_MEDIAN), max(DP2D_CNR), max(DP2D_CNR_MEDIAN)]);

% Create bins
edges = linspace(minValue, maxValue, 30);

% Compute histograms for each vector
histogram1 = histcounts(DP1D_CNR, edges, 'Normalization', 'probability');
histogram2 = histcounts(DP1D_CNR_MEDIAN, edges, 'Normalization', 'probability');
histogram3 = histcounts(DP2D_CNR, edges, 'Normalization', 'probability');
histogram4 = histcounts(DP2D_CNR_MEDIAN, edges, 'Normalization', 'probability');

% Create a side-by-side bar plot for comparison
figure;
bar(edges(1:end-1), [histogram1; histogram2; histogram3; histogram4]', 'BarWidth', 0.8);

% Set different colors for each bar
colormap([0 0 1; 1 0 0]);  % Blue for Vector 1, Red for Vector 2

% Add labels and title
xlabel('CNR');
ylabel('Normalized Freauency');

% Display the legend
legend('DP 1D', 'DP 1D MEDIAN' , 'DP 2D' , 'DP 2D MEDIAN');

% Display the grid
grid on;


% SNR
S1D_SNR = snr(strain1D, 20);
S1DM_SNR = snr(median_strain1D, 20);
S2D_SNR = snr(strain2D, 50);
S2DM_SNR = snr(median_strain2D, 20);

S1D_SNR
S1DM_SNR
S2D_SNR
S2DM_SNR

