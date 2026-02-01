function vals = gca_get_values(A, ii, jj)
    % sub2ind is slow, linear indexing into sparse is better
    linIdx = ii + (jj-1)*size(A,1);
    vals = A(linIdx);
end