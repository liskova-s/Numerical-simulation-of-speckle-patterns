function arr = centered_cut(A, sz)
    s = size(A);
    s = s./2;
    arr = A(s(1)-sz(1)/2+1:s(1)+sz(1)/2,s(2)-sz(2)/2+1:s(2)+sz(2)/2);
end