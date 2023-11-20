function snrValue = snr(ImageArray, windowSize)
    % Extract a window from the image
    window = ImageArray(20:20+windowSize-1, 20:20+windowSize-1);

    % Calculate the mean of the window
    meanValue = mean(window, 'all');

    % Calculate the variance of the window
    tmp = sum((window - meanValue).^2, 'all');
    variance = sqrt(tmp / (numel(window)));

    % Calculate SNR in dB
    snrValue = 20 * log10(meanValue / variance);
end
