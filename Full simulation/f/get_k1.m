function k1 = get_k1(k)
    n = [0,0,1]; % normal vector of the SLM (always fixed)
    k1 = k - 2*(dot(k,n))*n;
end
