function strain_map = Strain_NCC(g, g_prime, beta, gamma, n)
    % Calculate strain using the correlation method with hierarchical search and subpixel estimation

    % Hierarchical search (downsampling)
    g_downsampled = g(1:beta:end);
    g_prime_downsampled = g_prime(1:beta:end);

    % DP on the downsampled signal
    integer_displacement = dynamic_programming(g_downsampled, g_prime_downsampled);

    % Initial guess for skipped samples
    interpolated_displacement = linear_interpolation(integer_displacement);

    % Refinement to subpixel displacement
    for i = 1:n
        % Upsample g_prime for parabolic interpolation
        g_prime_upsampled = upsample(g_prime, gamma);

        % Parabolic interpolation for refinement
        refined_displacement = parabolic_interpolation(g, g_prime_upsampled);

        % Update the interpolated_displacement for the next iteration
        interpolated_displacement = refined_displacement;
    end

    % Calculate strain map based on the final displacement estimates
    strain_map = calculate_strain_from_displacement(interpolated_displacement);
end

