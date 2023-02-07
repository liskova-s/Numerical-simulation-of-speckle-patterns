function k1 = get_k0(L_coord, beam_center,lambda, slm_pixel,slm_resolution)
% returning  wave vector k
    [bcx,bcy] = pixel_to_coord(beam_center(1),beam_center(2),slm_pixel,slm_resolution);
    k1 = [bcx-L_coord(1)-slm_pixel/2,bcy-L_coord(2)+slm_pixel/2,0-L_coord(3)];
    k1 = k1./norm(k1)*2*pi/lambda;
end

