function delta = delta1d(i, d, g, g_prime)
    delta = abs(g(i) - g_prime(i+d));
%     rawIdx = i + d;
%     maxIdx = length(g);
%     if any(rawIdx > maxIdx) || any(rawIdx < 1)
%         delta = nan;
%     else
%         delta = abs(g(i) - g_prime(rawIdx));
%     end

end