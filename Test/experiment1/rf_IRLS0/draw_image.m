clear all
load Im0.mat % This line loads Im0, which is RF data


% We have to convert it to B-mode data for display
% Use RF data for calculating tissue displacement. Bmode data is ONLY for display
BMODE = log(abs(hilbert(Im0(:,:)/max(Im0(:))))+.001);
figure, imagesc(BMODE(1:end,:)); colormap(gray)


