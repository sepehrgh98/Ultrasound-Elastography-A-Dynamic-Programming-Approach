function [I_Mag,I_Edge] = Strain1D(arguments)
    arguments
        arguments.image(1,:) mustBeNumeric;
        arguments.h(1,:) mustBeNumeric = [-1,0,1];
        arguments.sigma(1,1) mustBeNumeric = 1;
    end
    length_G = ceil(length(arguments.h)*arguments.sigma);
    G_V = -length_G:length_G;
    G = exp(-G_V.^2/(2*arguments.sigma^2));
    G = G/sum(G);
    I_Smooth = conv(arguments.image,G,'same');
    I = conv(I_Smooth,arguments.h,'same');
    I_Mag = sqrt(I.*I);
    I_G_M = mean(I_Mag(:));
    I_G_STD = std(I_Mag(:));
    I_Edge = I_Mag > (I_G_M + I_G_STD);
end