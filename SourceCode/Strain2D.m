function [I_Mag,I_Edge] = Strain2D(arguments)
    arguments
        arguments.image(:,:) mustBeNumeric;
        arguments.h_x(1,:) mustBeNumeric = [-1,0,1];
        arguments.h_y(:,1) mustBeNumeric = [-1;0;1];
        arguments.sigma(1,1) mustBeNumeric = 1;
    end
    if(length(arguments.h_x) ~= length(arguments.h_y))
        error("(h_x,h_y) Dimension Mismatch!!!");
    end
    length_G = ceil(length(arguments.h_x)*arguments.sigma);
    G_V = -length_G:length_G;
    G = exp(-G_V.^2/(2*arguments.sigma^2));
    G = G/sum(G);
    G_2D = G'*G;
    I_Smooth = conv2(arguments.image,G_2D,'same');
    I_X = conv2(I_Smooth,arguments.h_x,'same');
    I_Y = conv2(I_Smooth,arguments.h_y,'same');
    I_Mag = sqrt(I_X.*I_X + I_Y.*I_Y);
    I_G_M = mean(I_Mag(:));
    I_G_STD = std(I_Mag(:));
    I_Edge = I_Mag > (I_G_M + I_G_STD);
end