function strain_magnitude = Strain(img)
    d_x = [-1 0 1];
    d_y = d_x';
    strain_magnitude = conv2(img, d_x);
    strain_magnitude = conv2(strain_magnitude, d_y);
%     % Calculate partial derivatives in x and y directions
%     du_dx = diff(img, 1, 2);
%     du_dy = diff(img, 1, 1);
%     
%     % Pad the derivatives to match the size of the displacement map
%     du_dx = [du_dx, zeros(size(du_dx, 1), 1)];
%     du_dy = [du_dy; zeros(1, size(du_dy, 2))];
%     
%     % Calculate strain components
%     epsilon_xx = du_dx;
%     epsilon_yy = du_dy;
%     epsilon_xy = 0.5 * (du_dx + du_dy);
%     
%     % Calculate the magnitude of the strain
%     strain_magnitude = sqrt(epsilon_xx.^2 + epsilon_yy.^2 + 2*epsilon_xy.^2);
end