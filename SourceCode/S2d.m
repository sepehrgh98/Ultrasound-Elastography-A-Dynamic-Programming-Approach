% dai = axial displacement
% dli = lateral displacement 
% dai_prev = the previous axial displacement
% dli_prev = the previous lateral displacemen


function S2d = S2d(dai, dli, dai_prev, dli_prev)
    size(dai_prev)
    size(dli_prev)
    S2d = (dai - dai_prev).^2 + (dli - dli_prev).^2;
end
