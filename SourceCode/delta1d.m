function delta = delta1d(rowIndex, disValue, g, g_prime)
    delta = abs(g(rowIndex) - g_prime(rowIndex+disValue));
end