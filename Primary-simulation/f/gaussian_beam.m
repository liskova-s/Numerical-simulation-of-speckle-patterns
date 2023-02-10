function U = gaussian_beam(lambda,P,w0,z0,z,slm_resolution,slm_pixel)
    k = 2*pi/lambda;
    c = 299792458; % [m/s]
    n = 1.000273; % at standard pressure
    epsilon =  8.854e-12;
    w = w0*(1+(z/z0)^2)^(1/2);
    R = z*(1+(z0/z)^2);
    I0 = 2*P/(pi*w^2);
    A0 = 2*I0/(c*epsilon*n);
    coord = SLM_coords(slm_resolution,slm_pixel);
    rho2 = coord(:,:,1).^2+coord(:,:,2).^2;
    U = A0.*w0./w.*exp(-rho2./w.^2).*exp(-1i.*k.*z-1i.*k.*rho2./(2.*R)+1i.*atan(z/z0));
end