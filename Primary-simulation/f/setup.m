function [source_coord, source_wave, slm_coord, mirror_coord, lens_coord] = setup(L_coord,beam_center,lambda,slm_pixel,slm_resolution, lens_size, lens_pixel,P,w0,z0,z)
    % returning coordinate grids based on provided parameters for further use
    
    % direction: source -> SLM
    k0 = get_k0(L_coord,beam_center,lambda,slm_pixel,slm_resolution);
    
    % coordinates and intensity of source wave
    ws = source_setup(slm_resolution.*2, lambda, P, w0, z0,z, slm_pixel,L_coord,k0);
    source_coord = ws(:,:,1:3);
    source_wave = gaussian_beam(lambda,P,w0,z0,z,slm_resolution.*2,slm_pixel);

    % coordinates of SLM
    slm_coord = SLM_coords(slm_resolution,slm_pixel);
    
    % coordinates of mirror
    mirror_coord = SLM_coords(lens_size,lens_pixel);
    
    % coordinates of lens
    lens_coord = SLM_coords(lens_size,lens_pixel);
end
