function del_2d=delta2d(rowIdx,colIdx,da,dl,g,g_prime)
    del_2d=abs(g(rowIdx,colIdx)-g_prime(rowIdx+da,colIdx+dl));
end