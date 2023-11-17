function cnr = calculate_cnr(target_strain, background_strain)

    % Calculate spatial averages
    mean_target = mean(target_strain(:));
    mean_background = mean(background_strain(:));

    % Calculate spatial variances
    var_target = var(target_strain(:));
    var_background = var(background_strain(:));

    % Calculate CNR
    cnr = sqrt(2 * (mean_background - mean_target)^2 / (var_background + var_target));
end
