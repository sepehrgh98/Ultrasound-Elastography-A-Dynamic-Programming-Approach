% d_i = the current displacement
% d_prev = the previous displacement


function smoothness = S1d(d_i, d_prev_vector, k)
    smoothness = abs(d_i - d_prev_vector).^k;
end
