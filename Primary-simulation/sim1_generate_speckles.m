function speckle_plane = sim1_generate_speckles(cam_plane,phase_mask)
% INPUT PARAMETERS:
% cam_plane - distance of observed plane from the lens [m]

% FIXED SETUP PARAMETERS 
    dist = 0.2; % distance aperture source - SLM
    slm_beam_center = [540,960]; % incident beam is centered in the middle of the SLM

% LASER Source (He-Ne) - beam properties and position:
    lambda = 632.8*10^(-9); % wavelength [m]  
    P = 1.5*1e-3; % beam power [W]
    w0 = 2e-3; % beam waist [m]
    z0 = pi*w0^2/lambda; % Rayleigh distance of beam
    z = 1e-16; % position of beam waist (z → 0)
    S_coord  = [0,0,dist]; % aperture A position coordinates [m]
    
% SLM - position
    slm_resolution = [1080,1920]; % resolution of SLM in pixels
    slm_pixel = 8*10^(-6); % pixel size: 8 um x 8um in [m]
    
% SLM - phase changing mask
    phases_change = imresize(phase_mask, slm_resolution*4,'nearest');
    
% LENS
    lens_d = 1;                 % distance SLM-lens [m]
    lens_size = [8000,8000];    % size oflens grid in [px]
    lens_diam = 0.025;          % diameter of lens [m]
    lens_pixel = 8*10^(-6)/4;   % size of pixel in lens grid [m]
    lens_f = 0.1;               % focal distance of lens [m]
      
% PROCESSING
addpath('.\f');
% source and system setup 
    k = [0,0,-1]; % wave vector representing aperture - SLM propagation
    source_wave = gaussian_beam(lambda,P,w0,z0,z,slm_resolution*7,slm_pixel/4); % create matrix with complex walues representing source field 
    source_coord = source_setup(size(source_wave), slm_pixel/4,S_coord,k); % get coordinate system for source

% propagation from the source (expander) to SLM
    slm_wave_in = propagate(source_wave,lambda,source_coord(:,:,1),source_coord(:,:,2),source_coord(:,:,3)); % propagated wave 
    slm_wave_crop = imresize(crop_to_slm_size(slm_wave_in,4*slm_resolution, 4*slm_beam_center),4*slm_resolution);

% apply SLM phase changes:
    slm_wave_out = slm_wave_crop.* exp(1i*phases_change).*exp(1i*pi);
    slm_wave_out_enlarged = enlarge(slm_wave_out,lens_size); % wave with applied phase changes in larger grid

% propagate to lens (SLM -> lens)
    lc = [0,0,lens_d]; % lens center coordinates
    lens_n = [0,0,1]; % normal vector to the lens plane
    lens_coord = get_lens_coord(lens_pixel,lens_size,lc,lens_n); % coordinate system for the lens

% apply effects of the lens
    lens_wave_in = propagate(slm_wave_out_enlarged,lambda,lens_coord(:,:,1),lens_coord(:,:,2),lens_coord(:,:,3));
    lens_wave_out = lens_phase_only(lens_wave_in,lens_coord(:,:,1),lens_coord(:,:,2),lambda,lens_f,lens_diam/2);
    lens_wave_out_large = enlarge(lens_wave_out, [8000,8000]);

% propagation to camera     
    speckle_plane = propagate(lens_wave_out_large,lambda, lens_coord(:,:,1),lens_coord(:,:,2),cam_plane);
end