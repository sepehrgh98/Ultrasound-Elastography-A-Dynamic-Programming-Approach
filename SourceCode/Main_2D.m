clc;
clear;
close all;

% Loading Data
% OriginalImg = [1 2 3 4 5;6 7 8 9 10;11 12 13 14 15; 16 17 18 19 20];
% CompressedImg = [2 3 4 5 6;7 8 9 10 11;6 7 9 10 15; 4 6 12 15 16];

load '../Data/Im0.mat'
maxIm = max(Im0(:));
OriginalImg = Im0/maxIm;

load '../Data/Im1.mat'
CompressedImg = Im1/maxIm;

% load '..\RFData\rf01.mat'
% OriginalImg = RfDataDouble(1:1700,:);
% maxIm = max(OriginalImg(:));
% OriginalImg = OriginalImg/maxIm;
% 
% 
% load '..\RFData\rf03.mat'
% CompressedImg = RfDataDouble(1:1700,:);
% CompressedImg = CompressedImg/maxIm;


% Defining Parameters
w=.15; %this is the regularization weight
[imHight, imWidth] = size(OriginalImg);
da_min = -100;
da_max = 0;
dl_min = -10;
dl_max = 10;
windowSize = 1;
da = da_min:1:da_max; % axial displacement vector
dl = dl_min:1:dl_max; % lateral displacement vector
noADisp = size(da,2); % number of possible axial displacements
noLDisp = size(dl,2); % number of possible lateral displacements
axialDisplacementMap = zeros(imHight, imWidth);
lateralDisplacementMap = zeros(imHight, imWidth);


disp 'Initialization...'

%Initialization
Pre_C = zeros(imHight,noADisp, noLDisp);
C = NaN(imHight,noADisp, noLDisp);

disp 'Process Started...';

for colIdx = 1:imWidth
    colIdx = colIdx
    g = OriginalImg;
    g_prime = CompressedImg;

    tmpDA = da + 1;
    tmpDA = (tmpDA>0) & (tmpDA <=imHight);

    stratIndexDeltaAx = find(tmpDA ==1 ,1 , 'first');
    endIndexDeltaAx = find(tmpDA ==1 ,1 , 'last');

    tmpDL = dl + colIdx;
    tmpDL = (tmpDL>0) & (tmpDL<=imWidth);

    
    stratIndexDeltaLat = find(tmpDL ==1 ,1 , 'first');
    endIndexDeltaLat = find(tmpDL ==1 ,1 , 'last');

    
    C(1, stratIndexDeltaAx:endIndexDeltaAx, ...
        stratIndexDeltaLat:endIndexDeltaLat) = delta2d(1, ...
        colIdx, da(stratIndexDeltaAx:endIndexDeltaAx), ...
        dl(stratIndexDeltaLat:endIndexDeltaLat), g, g_prime);

    M = NaN(imHight, noADisp, noLDisp,2); % 1 for Axial and 2 for Lateral
    for rowIdx = 2:imHight
        minimizedValues = NaN(noADisp, noLDisp);
        minimizedValuesIndex =  NaN(noADisp, noLDisp,2); % 1 for Axial and 2 for Lateral
        delta = NaN(noADisp, noLDisp);

        tmpDA = da + rowIdx;
        tmpDA = (tmpDA>0) & (tmpDA <=imHight);

        startADis = find(tmpDA ==1 ,1 , 'first');
        endADis = find(tmpDA ==1 ,1 , 'last');

        for axDisIdx = startADis:endADis
            startLDis = stratIndexDeltaLat;
            endLDis = endIndexDeltaLat;
            for latDisIdx = startLDis:endLDis
                selectedAIdx = max(axDisIdx - windowSize,1):min(axDisIdx + windowSize,noADisp);
                selectedLIdx = max(latDisIdx - windowSize,1):min(latDisIdx + windowSize,noLDisp);
              
                P1 = reshape(Pre_C(rowIdx,selectedAIdx, selectedLIdx), length(selectedAIdx), length(selectedLIdx));
                P2 = reshape(C(rowIdx -1 ,selectedAIdx, selectedLIdx), length(selectedAIdx), length(selectedLIdx));
                

                Smooth = S2d(da(axDisIdx), dl(latDisIdx), ...
                    repmat(da(selectedAIdx)', 1, length(selectedLIdx)), ...
                    repmat(dl(selectedLIdx),length(selectedAIdx),1));
                
                a = (P1 + P2)/2 + w * Smooth;
                
                minValue = min(a(:));
                [minAIdx,minLIdx] = find(a==minValue, 1, 'first');

                if axDisIdx == 1
                    minAIdx = minAIdx +1;
                end

                if latDisIdx == 1
                    minLIdx = minLIdx+1;
                end
                
                expectedAIdx = (minAIdx - 2) + axDisIdx;
                expectedAIdx = max(expectedAIdx,1);
                expectedLIdx = (minLIdx - 2) + latDisIdx;
                expectedLIdx = max(expectedLIdx,1);
                minimizedValues(axDisIdx, latDisIdx) = minValue;
                minimizedValuesIndex(axDisIdx, latDisIdx,1) = expectedAIdx; 
                minimizedValuesIndex(axDisIdx, latDisIdx,2) = expectedLIdx;
                delta(axDisIdx, latDisIdx) = delta2d(rowIdx, colIdx, da(axDisIdx), dl(latDisIdx), g, g_prime);
            end
        end 
    
        C(rowIdx, :, :) = minimizedValues + delta;
        M(rowIdx, :, :, :) = minimizedValuesIndex;
    end
    if all(isnan(M(:)))
        continue;
    end
    lastCost = reshape(C(imHight,:,:), noADisp, noLDisp);
    
    minCost = min(lastCost(:));
    [minACIdx,minLCIdx] = find(lastCost==minCost, 1, 'first');
    
    D_idx = zeros(imHight,2); % 1 for Axial and 2 for Lateral
    D_idx(imHight,:) = [minACIdx, minLCIdx];
    
    for j = imHight-1 : -1 : 1
        D_idx(j,:) = reshape(M(j+1,D_idx(j+1,1), D_idx(j+1,2),:),1 ,2);
    end 
    axialDisplacementMap(:,colIdx) = da(D_idx(:,1))';
    lateralDisplacementMap(:,colIdx) = dl(D_idx(:,2))';
    Pre_C = C;
    C = NaN(imHight,noADisp, noLDisp); 
end

disp 'Process Finished...';
disp 'Showing Results...';

% Results
figure;imagesc(axialDisplacementMap); colormap gray; colorbar; title('Axial Displacement');
axialDisplacementMap_median=medfilt2(axialDisplacementMap);
figure;imagesc(axialDisplacementMap_median); colormap gray; colorbar; title('Axial Displacement Median filtered');

figure;imagesc(lateralDisplacementMap); colormap gray; colorbar; title('Lateral Displacement');
lateralDisplacementMap_median=medfilt2(lateralDisplacementMap);
figure;imagesc(lateralDisplacementMap_median); colormap gray; colorbar; title('Lateral Displacement Median filtered');

disp 'Saving Results....';

% save('..\Results\ex1\DP_2D\AxialDisplacementMap2D.mat', 'axialDisplacementMap');
% save('..\Results\ex1\DP_2D\AxialDisplacementMapMedian2D.mat', 'axialDisplacementMap_median');
% 
% save('..\Results\ex1\DP_2D\LateralDisplacementMap2D.mat', 'lateralDisplacementMap');
% save('..\Results\ex1\DP_2D\LateralDisplacementMapMedian2D.mat', 'lateralDisplacementMap_median');

save('..\Results\ex2\DP_2D\AxialDisplacementMap2D_ex2.mat', 'axialDisplacementMap');
save('..\Results\ex2\DP_2D\AxialDisplacementMapMedian2D_ex2.mat', 'axialDisplacementMap_median');

save('..\Results\ex2\DP_2D\LateralDisplacementMap2D_ex2.mat', 'lateralDisplacementMap');
save('..\Results\ex2\DP_2D\LateralDisplacementMapMedian2D_ex2.mat', 'lateralDisplacementMap_median');

disp 'Results have been saved!';


