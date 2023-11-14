% d_i = the current displacement
% d_prev = the previous displacement


function smoothness = one_dim_smooth_function(d_i, d_prev, k)
    smoothness = abs(d_i - d_prev)^k;
end
