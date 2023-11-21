clc;
clear;

% Loading Data
OriginalImg = [1 2 3 4 5;6 7 8 9 10;11 12 13 14 15; 16 17 18 19 20];
CompressedImg = [2 3 4 5 6;7 8 9 10 11;6 7 9 10 15; 4 6 12 15 16];

% Defining Parameters
w=.15; %this is the regularization weight
[imHight, imWidth] = size(OriginalImg);
da_min = -3;
da_max = 0;
dl_min = -2;
dl_max = 0;
windowSize = 1;
da = da_min:1:da_max; % axial displacement vector
dl = dl_min:1:dl_max; % lateral displacement vector
noADisp = size(da,2); % number of possible axial displacements
noLDisp = size(dl,2); % number of possible lateral displacements
axialDisplacementMap = zeros(imHight, imWidth);
lateralDisplacementMap = zeros(imHight, imWidth);
numNegativeAxialDis = sum(da <= 0);
numNegativeLateralDis = sum(dl <= 0);


disp 'Initialization...'

%Initialization
Pre_C = zeros(imHight,noADisp, noLDisp);
C = NaN(imHight,noADisp, noLDisp);

disp 'calculating displacement map'

for colIdx = 1:imWidth
    g = OriginalImg;
    g_prime = CompressedImg;
    C(1, numNegativeAxialDis:end, numNegativeLateralDis:end) = delta2d(1,colIdx, da(numNegativeAxialDis:end), dl(numNegativeLateralDis:end), g, g_prime);
    
    for rowIdx = 2:imHight
        startADis = max(numNegativeAxialDis - rowIdx + 1, 1);
        endADis = noADisp;
        for axDisIdx = startADis:endADis
            startLDis = max(numNegativeLateralDis - colIdx + 1, 1);
            endLDis = noLDisp;
            for latDisIdx = startLDis:endLDis
            
                selectedAIdx = max(axDisIdx - windowSize,1):min(axDisIdx + windowSize,noADisp);
                selectedLIdx = max(latDisIdx - windowSize,1):min(latDisIdx + windowSize,noLDisp);
           
                P1 = Pre_C(rowIdx,selectedAIdx, selectedLIdx);
                P2 = C(rowIdx -1 ,selectedAIdx, selectedLIdx);

                Smooth = S2d(da(axDisIdx), dl(latDisIdx), ...
                    repmat((da(selectedAIdx))', 1, length(selectedLIdx)), ...
                    repmat(dl(selectedLIdx),length(selectedLIdx),1));
%                 v=(P1 + P2)/2 + w * Smooth;
                
                break;
            end
            break;
        end 
        break;
    end
   
    break;
end

