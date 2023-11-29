function cnrValues = CNR(image, targetWindowFirstPoint, targetWindowLastPoint)

    targetWindow = image(targetWindowFirstPoint(1):targetWindowLastPoint(1) ...
                   , targetWindowFirstPoint(2):targetWindowLastPoint(2));

    targetSize = size(targetWindow);
    
   % Get the size of the image
    [imageHeight, imageWidth] = size(image);
    
    % Calculate the size of each non-overlapping window
    windowSize = floor([imageHeight, imageWidth] / sqrt(36));

    cnrValues = zeros(6,6);

%     hold on;  
%     rectangle('Position', [targetWindowFirstPoint(2), targetWindowFirstPoint(1), targetSize(2), targetSize(1)], 'EdgeColor', 'g', 'LineWidth', 2);
%     hold off;
    
    % Extract non-overlapping windows
    for col = 1:6
        startCol = (col - 1) * windowSize(2) + 2;
        endCol = startCol + windowSize(2) - 1;

        for row = 1:6
            % Define the window boundaries
            startRow = (row - 1) * windowSize(1) + 2;
            endRow = startRow + windowSize(1) - 1;

            % Extract the window from the image
            backgroundWindow = image(startRow:endRow, startCol:endCol);
            cnrValues(row, col) = calculateCNR(targetWindow, backgroundWindow);


%             hold on;
%             rectangle('Position', [startCol, startRow, windowSize(2), windowSize(1)], 'EdgeColor', 'r', 'LineWidth', 2);
%             hold off;

        end
    end


end

function cnrValue = calculateCNR(targetWindow, backgroundWindow)
    
    % Calculate mean and standard deviation for target and background
    meanTarget = mean(targetWindow(:));
    meanBackground = mean(backgroundWindow(:));
    varTarget = var(targetWindow(:));
    varBackground = var(backgroundWindow(:));
    % Calculate CNR
    cnrValue = sqrt(2*(meanBackground - meanTarget)^2 / (varTarget + varBackground));
end




