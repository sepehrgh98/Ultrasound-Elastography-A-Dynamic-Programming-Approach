clear all
load Im2.mat % This line loads Im2, which is RF data


% We have to convert it to B-mode data for display
% Use RF data for calculating tissue displacement. Bmode data is ONLY for display
BMODE = log(abs(hilbert(Im2(:,:)/max(Im2(:))))+.001);
figure, imagesc(BMODE(1:end,:)); colormap(gray)


