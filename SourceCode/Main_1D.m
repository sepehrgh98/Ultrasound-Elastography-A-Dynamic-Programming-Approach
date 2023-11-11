clc;
clear;

% Loading data
g=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15];
g_prime=[0;2;3;4;6;7;8;9;10;9;10;11;12;13;14];

% Initialization
w=.15; %this is the regularization weight
[imHight, imWidth] = size(g);
dmin = -3;
dmax = 3;
windowSize = 1;
d = dmin:1:dmax; % displacement vector
noDisp = size(d,2); % number of possible displacements
C = zeros(imHight, noDisp); % Costs storge (pixel => displacement vector)
M = NaN(imHight, noDisp);
D = zeros(imHight,1);
displacementMap = zeros(imHight, imWidth);

% Initialize First row  
C(1,:) = delta1d(1, d);

for pixIdx = 2:imHight
    minimizedValues = NaN(1, noDisp);
    minimizedValuesIndex =  NaN(1, noDisp);
    for disIdx = 1:noDisp
        preC = C(pixIdx - 1,disIdx - windowSize:windowSize + windowSize);
        [minValue, minIdx] = min(preC + w*S(d(disIdx), d(disIdx - windowSize:disIdx + windowSize)));
        minimizedValues(1, disIdx) = minValue;
        minimizedValuesIndex(1, disIdx) = (minIdx - 2) + disIdx;
    end
    C(pixIdx,:) = minimizedValues + delta1d(pixIdx, d);
    M(pixIdx,:) = minimizedValuesIndex;
end
% Traceback Index
[~, D(end, 1)] = min(C(end, :));

for mIdx = imHight-1:-1:1
    D(mIdx, 1) = M(mIdx+1, D(mIdx+1, 1));
end

displacementMap(:, 1) = D;


