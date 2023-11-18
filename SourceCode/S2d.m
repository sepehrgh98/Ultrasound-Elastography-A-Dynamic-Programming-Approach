% dai = axial displacement
% dli = lateral displacement 
% dai_prev = the previous axial displacement
% dli_prev = the previous lateral displacemen


function smoothness_2d = S2d(dai, dli, dai_prev, dli_prev)
    smoothness_2d = (dai - dai_prev)^2 + (dli - dli_prev)^2;
end
