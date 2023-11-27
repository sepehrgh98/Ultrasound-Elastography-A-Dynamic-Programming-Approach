clear all
load Im1.mat % This line loads Im1, which is RF data


% We have to convert it to B-mode data for display
% Use RF data for calculating tissue displacement. Bmode data is ONLY for display
BMODE = log(abs(hilbert(Im1(:,:)/max(Im1(:))))+.001);
figure, imagesc(BMODE(1:end,:)); colormap(gray)


