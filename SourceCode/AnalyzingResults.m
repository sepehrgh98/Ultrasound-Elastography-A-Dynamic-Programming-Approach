clc;
clear;
close all;


load('..\Results\DP_1D\DisplacementMap1D.mat');
load('..\Results\DP_1D\DisplacementMapMedian1D.mat');

figure;imagesc(displacementMap); colormap gray; colorbar; title('Axial Displacement');
figure;imagesc(displacementMap_median); colormap gray; colorbar; title('Axial Displacement Median');

fprintf('Calculating 1D DP Strain ... \n');

figure;imagesc(Strain(displacementMap)); colormap gray; colorbar; title('Strain 1D DP');
figure;imagesc(Strain(displacementMap_median)); colormap gray; colorbar; title('Strain 1D DP Median');
