clc;
clear all

% Loading data
% OriginalImg=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15];
% CompressedImg=[0;2;3;4;6;7;8;9;10;9;10;11;12;13;14];

% load '..\RFData\rf01.mat'
% OriginalImg = RfDataDouble(1:1700,:);
% maxIm = max(OriginalImg(:));
% OriginalImg = OriginalImg/maxIm;
% 
% 
% load '..\RFData\rf03.mat'
% CompressedImg = RfDataDouble(1:1700,:);
% CompressedImg = CompressedImg/maxIm;


load '../Data/Im0.mat'
maxIm = max(Im0(:));
OriginalImg = Im0/maxIm;

load '../Data/Im1.mat'
CompressedImg = Im1/maxIm;



See_B_mode = 1;
if See_B_mode
    BMODE1 = log(abs(hilbert(OriginalImg))+.01);
    figure,  imagesc(BMODE1);colormap(gray), colorbar
    BMODE2 = log(abs(hilbert(CompressedImg))+.01);
    figure, imagesc(BMODE2);colormap(gray), colorbar
end


% Initialization
w=.15; %this is the regularization weight
[imHight, imWidth] = size(OriginalImg);
dmin = -100;
dmax = 0;
windowSize = 1;
d = dmin:1:dmax; % displacement vector
noDisp = size(d,2); % number of possible displacements
displacementMap = zeros(imHight, imWidth);
numNegativeDis = sum(d <= 0);

disp 'Process Started...';


for colIdx = 1:imWidth
    colIdx = colIdx
    % Initialization
    g = OriginalImg(:,colIdx);
    g_prime = CompressedImg(:,colIdx);
    C = NaN(imHight, noDisp); % Costs storge (pixel => displacement vector)
    M = NaN(imHight, noDisp);
    D = zeros(imHight,1);
    
    % Initialize First row  
    C(1,numNegativeDis:end) = delta1d(1,d(numNegativeDis:end), g,  g_prime);

    for pixIdx = 2:imHight
        minimizedValues = NaN(1, noDisp);
        minimizedValuesIndex =  NaN(1, noDisp);
        delta = NaN(1,noDisp);
        startDis = max(numNegativeDis - pixIdx + 1, 1);
        endDis = noDisp;
        for disIdx = startDis:endDis
            selectedIdx = max(disIdx - windowSize,1):min(disIdx + windowSize,noDisp);
            preC = C(pixIdx - 1,selectedIdx);
            [minValue, minIdx] = min(preC + w*S1d(d(disIdx), d(selectedIdx), 2));
            if disIdx == 1 
                minIdx = minIdx+1;
            end
            minimizedValues(1, disIdx) = minValue;
            expectedIdx = (minIdx - 2) + disIdx;
            expectedIdx = max(expectedIdx,1);
            minimizedValuesIndex(1, disIdx) = expectedIdx;
            delta(1, disIdx) = delta1d(pixIdx, d(disIdx),g, g_prime);
        end
        C(pixIdx,:) = minimizedValues + delta;
        M(pixIdx,:) = minimizedValuesIndex; 
    end
    [val,idx]=min(C(imHight,:));
    D_idx=zeros(imHight,1);
    D_idx(imHight)=idx;
    for i=1:imHight-1
        j=imHight-i;
        D_idx(j)=M(j+1,D_idx(j+1));
    end

    D=d(D_idx)';
    displacementMap(:,colIdx)=D;
end

disp 'Process Finished...';
disp 'Showing Results...';

% Results
figure;imagesc(displacementMap); colormap hot; colorbar; title('Axial Displacement');
displacementMap_median=medfilt2(displacementMap);
figure;imagesc(displacementMap_median); colormap gray; colorbar; title('Axial Displacement Median filtered');

disp 'Saving Results....';
save('..\Results\DP_1D\DisplacementMap1D.mat', 'displacementMap');
save('..\Results\DP_1D\DisplacementMapMedian1D.mat', 'displacementMap_median');

disp 'Results have been saved!';



