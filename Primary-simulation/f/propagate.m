function conv = propagate(wave,lambda, x_coords,y_coords,z)
    % Rayleigh-Sommerfield impulse response h:
    kAmp = 2*pi/lambda;
    rSq = x_coords.^2+y_coords.^2+z.^2;
    h = z.*exp(1i*kAmp*sqrt(rSq))./(1i.*lambda.*rSq);

    % size + padding
    [m,n] = size(wave);
    [mb,nb] = size(h);
    mm = m + mb - 1;
    nn = n + nb - 1;

    % pad, multiply and transform back
    C = ifft2(fft2(wave,mm,nn).* fft2(h,mm,nn));
    padC_m = ceil((mb-1)./2);
    padC_n = ceil((nb-1)./2);
    conv = C(padC_m+1:m+padC_m, padC_n+1:n+padC_n);
    [x,y] = size(wave);
    if conv(x/2,y/2) < 0
        conv = -1.*conv;
    end
   
end

