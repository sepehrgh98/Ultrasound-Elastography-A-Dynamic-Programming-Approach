function cnrVal = CNR(image, targetWindowFirstPoint, targetWindowLastPoint, marginSize, M)

    targetWindow = image(targetWindowFirstPoint(1):targetWindowLastPoint(1) ...
                   , targetWindowFirstPoint(2):targetWindowLastPoint(2));

    % Calculate the size of the target window
    [targetH, targetW] = size(targetWindow);

    cnrValues = zeros(1,M+1);
    for i = 0 : M
        backgroundWindow = image(marginSize:marginSize+targetW, marginSize + i:marginSize+targetH + i);
        cnrValues(i+1) = calculateCNR(targetWindow, backgroundWindow);
    end

    cnrVal = mean(cnrValues);
end

function cnrValue = calculateCNR(targetWindow, backgroundWindow)
    
    % Calculate mean and standard deviation for target and background
    meanTarget = mean(targetWindow(:));
    meanBackground = mean(backgroundWindow(:));

    stdTarget = std(double(targetWindow(:)));
    stdBackground = std(double(backgroundWindow(:)));

    % Calculate CNR
    cnrValue = abs(meanTarget - meanBackground) / sqrt((stdTarget^2 + stdBackground^2) / 2);
end