function snrValue = snr(ImageArray, windowSize)
    [imHight, imWidth] = size(ImageArray);
    center = [ceil(imHight/2), ceil(imWidth/2)];
    % Extract a window from the image
    window = ImageArray(center(1) - ceil(windowSize/2):center(1) - ceil(windowSize/2), ...
                        center(2) - ceil(windowSize/2):center(2) - ceil(windowSize/2));

    % Calculate the mean of the window
    meanValue = mean(window, 'all');

    % Calculate the variance of the window
    tmp = sum((window - meanValue).^2, 'all');
    variance = sqrt(tmp / (numel(window)));

    % Calculate SNR in dB
    snrValue = 20 * log10(meanValue / variance);
end
