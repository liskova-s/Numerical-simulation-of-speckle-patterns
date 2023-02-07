clear all;
close all;
clc;

addpath('.\f');
%% PARAMETERS AND SETUP
% PLUTO SLM 
    slm_resolution = 4*[1080,1920];             % SLM resolution [pixels]
    slm_pixel = 8*10^(-6)/4;                    % pixel size: 8 um x 8um in [m]
    beam_center = 4*[540,960];                  % coordinates of estimated beam center in pixels (pixels are being counted from upper left corner)

% LASER (He-Ne)____________________________________________________________
    % position 
    dist = 0.2;                                 % source - SLM distance [m]                 
    L_coord = [0,0, dist];                      % source position coordinates
    
    % laser properties - Gaussian beam model
    lambda = 632.8*10^(-9);                     % [m]  
    P = 0.001;                                  % laser power [W]
    w0 = 3.2e-6;                                % beam waist [m]
    w_exp = 4e-2;                               % source (expander) beam width [m]
    z0 = pi*w0^2/lambda;
    z = z0*((w_exp/w0)^2 - 1)^(1/2);

% LENS
    lens_z = 1;                                 % z  position of lens (distance form SLM)[m]
    lens_size = [8000,8000];                    % coordinate grid for the lens [pixels]
    lens_diam = 0.015;                          % aperture diameter [m]
    lens_pixel = 8*10^(-6)/4;                   % pixel size: 8 um x 8um in [m]
    lens_f = 0.1;                               % focal distance of lens [m]

% MIRROR
    mirror_z = 0.5;                             % z position of mirror (distance from SLM) [m]

%SLM - phase change
    % phase change using QR-code-like structure 
    p_change = cell2mat(struct2cell(load('qr_mask_slm.mat')));
    p_change = p_change*pi;
    p_change = kron(p_change,ones(4));
    
    % different phase change implementations are provided in
    % 'phase_chnages.m' file
    

% VISUALISATION
    z_plane = 1e-3;                                 % z distance of the plane of observation from the focus of lens

    
%% PROCESSING

    % setup:
    [source_coord, source_wave , slm_coord, mirror_coord, lens_coord] = setup(L_coord,beam_center,lambda,slm_pixel,slm_resolution,lens_size, lens_pixel,P,w0,z0,z);
   
    % propagation from the source (expander) to SLM
    slm_wave_in = propagate(source_wave,lambda,source_coord(:,:,1),source_coord(:,:,2),source_coord(:,:,3));
   
    cropped = crop_to_slm_size(slm_wave_in,slm_resolution, beam_center,source_coord(:,:,1),source_coord(:,:,2),source_coord(:,:,3));
    slm_wave_out = cropped(:,:,4);

    % apply SLM phase changes:
    slm_wave_out = slm_wave_out.* exp(1i*p_change).*exp(1i*pi);

    % propagate to mirror (SLM -> mirror)
    slm_wave_out_enlarged = enlarge(slm_wave_out,lens_size);
    mirror_wave_in = propagate(slm_wave_out_enlarged,lambda,mirror_coord(:,:,1),mirror_coord(:,:,2),mirror_z*ones(size(slm_wave_out_enlarged)));

    % apply mirror phase change
    mirror_wave_out = mirror_wave_in .* exp(1i*pi*ones(lens_size));
    
    % propagate to lens (mirror -> lens)
    lens_wave_in = propagate(mirror_wave_out,lambda,lens_coord(:,:,1),lens_coord(:,:,2),(lens_z-mirror_z)*ones(size(mirror_wave_out)));
  
    % applying the aperture function of lens
    lens_wave_out = lens_phase_only(lens_wave_in,lens_coord(:,:,1),lens_coord(:,:,2),lambda,lens_f,lens_diam/2);
      
    % propagation back of lens -> observed plane
    focus_plane  = propagate(lens_wave_out,lambda,source_coord(:,:,1),source_coord(:,:,2), lens_f);
    speckles = propagate(lens_wave_out,lambda,source_coord(:,:,1),source_coord(:,:,2), lens_f+z_plane);
    
    % correlation degree - observed plane and focal plane (means subtracted)
    corr = corr2(abs(speckles(3500:4500,3000:4000))-mean(abs(speckles(3500:4500,3000:4000)),'all'),abs(focus_plane(3500:4500,3000:4000))-mean(abs(focus_plane(3500:4500,3000:4000)),'all'));
   

%% VISUALISATION

figure()
subplot 311
imagesc(p_change);
title('Used phase mask')

subplot 312
imagesc(abs(focus_plane));
title('Focal plane pattern')

subplot 313
imagesc(abs(speckles));
title(sprintf('Pattern in observed plane %.2f mm from focus \n Correlation degree: %.3f',z_plane*1e3,corr))










