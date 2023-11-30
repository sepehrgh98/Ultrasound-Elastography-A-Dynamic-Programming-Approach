function snrValue = snr(ImageArray, windowSize)
    [imHight, imWidth] = size(ImageArray);

    xcenter = randi([windowSize+1, imHight - windowSize-1], 1, 10);
    ycenter = randi([windowSize+1, imWidth - windowSize-1], 1, 10);

    snrVector = zeros(1,10);
    
    for i = 1:length(xcenter)
        window = ImageArray(xcenter(i) - ceil(windowSize/2):xcenter(i) + ceil(windowSize/2), ...
                        ycenter(i) - ceil(windowSize/2):ycenter(i) + ceil(windowSize/2));

        % Calculate the mean of the window
        meanValue = mean(window, 'all');
    
        % Calculate the variance of the window
        variance = var(window(:));
        
%         hold on;
%         rectangle('Position', [ycenter(i) - ceil(windowSize/2), xcenter(i) - ceil(windowSize/2), windowSize, windowSize], 'EdgeColor', 'r', 'LineWidth', 2);
%         hold off;

    
        % Calculate SNR in dB
        snrVector(i) = 20 * log10(meanValue / variance);
    end
    snrValue = mean(snrVector);
end
