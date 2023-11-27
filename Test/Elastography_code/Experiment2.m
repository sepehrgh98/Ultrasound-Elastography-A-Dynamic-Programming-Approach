% Copyright, 2009, Hassan Rivaz.  All Rights reserved.
% Permission granted to download and use AM2D, Kal_LSQ and LSQ for 
% non-commercial research use only.  No further distribution or copying 
% permitted without express written consent of Hassan Rivaz. contact: rivaz@jhu.edu 
% Contact Taylor L. Jordan, Licensing Associate, 
% We might release the source codes in the future

% Please cite the following two papers if you are using this code or the
% accompanying RF-data 
% [1] 3. Rivaz, H., Boctor, E., Foroughi, P., Zellars, R., Fichtinger, G.,
% Hager, G., “Ultrasound Elastography: a Dynamic Programming Approach”, 
% IEEE Trans. Medical Imaging Oct. 2008, vol. 27 pp 1373-1377
% [2] Rivaz, H., Boctor, E., Choti, M., Hager, G., “Regularized Ultrasound
% Elastography”, IEEE Trans. Medical Imaging (2011)

% IRF: the range of variation of axial displacement. set it to:
% [-a 0] if compression
% [0 b] if extension
% [-a b] if not sure

% IA: the range of variation of lateral displacement. set it to:
% [-a 0] if moved to the left
% [0 b] if moved to the right
% [-a b] if not sure

% midA: the seed RF-line where the displacement calculation starts from

clear all
close all

load '../experiment1/rf_IRLS0/Im0.mat'
maxIm = max(Im0(:));
Im0 = Im0/maxIm;

load '../experiment1/rf_IRLS1/Im1.mat'
Im1 = Im1/maxIm;


% ------------------------------------------------------- %
% ------------- set See_B_mode to see B-mode ------------ %
% ------------------------------------------------------- %
See_B_mode = 1;
if See_B_mode
    BMODE1 = log(abs(hilbert(Im0(40:end-40,10:end-10)))+.01);
    figure,  imagesc(BMODE1);colormap(gray), colorbar
    BMODE2 = log(abs(hilbert(Im1(40:end-40,10:end-10)))+.01);
    figure, imagesc(BMODE2);colormap(gray), colorbar
end
% ---------------------------------------- %
% ------------- DP Paerametes ------------ %
% ---------------------------------------- %
IRF = [-100 0];
IA = [4 4]; %Maximum allowed disparity in lateral D
alfa_DP = 0.15; % DP regularization weight
% ---------------------------------------- %
% ------------ 2D AM Paerametes ---------- %
% ---------------------------------------- %
midA = 100;
alfa = 5; %axial regularization
beta = 10; %lateral regularization
gamma = 0.005; %lateral regularization 
T = .2; % threshold for IRLS

[D1, D2, DPdisparity] = AM2D(Im0, Im1, IRF, IA, midA, alfa_DP, alfa, beta, gamma, T, 1);
% the disp. of the first 40 and last 40 samples is not calculated in AM2D: 
% the disp. of the first 10 and last 10 A-lines is not calculated in AM2D: 
figure, imagesc(D1), colorbar, title('axial displacement'), colormap(hot)
figure, imagesc(D2), colorbar, title('lateral displacement'), colormap(hot)
% DPdisp is the displacement of the midA calculated by DP
% ---------------------------------------------------- %
% ------------ Calculating Strain from Disp ---------- %
% ---------------------------------------------------- %
wDIff = 43;
[strain1] = LSQ(D1(41:end-41,11:end-10),wDIff);

strain1 = strain1((wDIff+1)/2:end-(wDIff-1)/2,:);

startA = 1; endA = size(strain1,2);
startRF = 100; endRF = size(strain1,1); 
figure; imagesc(-strain1(startRF:endRF, startA:endA));
colorbar; colormap(gray); title('elastography')

