function strain_magnitude = Strain(img)
    sigma = 2;
    d_x = [-1 0 1];

    % Apply Gaussian filter using imgaussfilt
    smoothed_image = imgaussfilt(img, sigma);

    strain_magnitude = conv2(smoothed_image, d_x);
end