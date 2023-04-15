function u2 = lens_phase_only(u1,X,Y,lambda,lens_f,lens_diam)
% returns wave u1 transformed by lens
k = 2*pi/lambda;            
P = ones(size(X));
Rsq = X.^2+Y.^2;
% aperture mask
P(Rsq>lens_diam^2) = 0; 

trans_function_Lens = P.*exp(-1i*k*(X.^2+Y.^2)./(2*lens_f));
u2 = trans_function_Lens.*u1;
end