function k1 = get_k1(k0)
    u  = k0';
    v = [0,0,1]';
    angle = rad2deg(subspace(u, v));
    if angle < 1e-18
        k1 = [k0(1),k0(2),-k0(3)];
    else
        A = [1 0; 0 1; 0 0];
        P = A*(A'*A)^(-1)*A';
        p = P*k0';
        k1 = [-p(1),-p(2),k0(3)];
        u  = k1';
        v = [0,0,1]';
        angle = rad2deg(subspace(u, v));
    end
end
