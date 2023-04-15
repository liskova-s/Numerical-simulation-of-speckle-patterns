function speckle_plane = sim2_generate_speckles(slm_angle,slm_beam_center,aperture,lens_angle,lens_beam_center,crosstalk_sigma,cam_angle,cam_plane,phase_mask)
% INPUT PARAMETERS:
% slm_angle - incident angle on SLM (alpha) [deg]
% slm_beam_center - coordinates of pixel where the beam center is incident [px]
% aperture - radius of aperture behind the expander [m]
% lens_angle - incident angle on the lens (beta) [deg]
% lens_beam_center - x,y distance of the beam center from the center of the
% lens [mm]
% crosstalk_sigma - sigma of Gaussian filter used to model pixel crosstalk
% cam_angle - incident angle on the camera (gamma) [deg]
% cam_plane - distance of observed plane from the lens [m]

% FIXED SETUP PARAMETERS 
expand_w = 0.008; % beam radius exiting the expander [m]
dist = 0.2; % distance aperture A - SLM
out_size = [8000,8000]; % size of output matrix

% LASER Source (He-Ne) - beam properties and position:
    lambda = 632.8*10^(-9); % wavelength [m]  
    P = 1.5*1e-3; % beam power [W]
    w0 = 0.315*1e-3; % beam waist [m]
    z0 = pi*w0^2/lambda; % Rayleigh distance of beam
    z = 1e-16; % position of beam waist (z → 0)
    [Sx,Sy,Sz] = source_c(dist,slm_angle); % aperture A position coordinates [m]
    S_coord = [Sx,Sy,Sz];
% SLM - position
    slm_resolution = [1080,1920]; % resolution of SLM in pixels
    slm_pixel = 8*10^(-6); % pixel size: 8 um x 8um in [m]
    
% SLM - phase changing mask
    phases_change0 = imresize(phase_mask, slm_resolution*4,'nearest');
    phases_change = crosstalk(phases_change0,crosstalk_sigma);
  
% LENS
    lens_d = 1;                 % distance SLM-lens [m]
    lens_size = [8000,8000];    % size oflens grid in [px]
    lens_diam = 0.025;          % diameter of lens [m]
    lens_pixel = 8*10^(-6)/4;   % size of pixel in lens grid [m]
    lens_f = 0.1;               % focal distance of lens [m]
      
% PROCESSING
addpath('.\f');
% source and system setup 
    k = get_k0(S_coord,slm_beam_center,lambda,slm_pixel,slm_resolution); % wave vector representing aperture - SLM propagation
    source_wave = gaussian_beam(lambda,P,w0,z0,z,slm_resolution*7,slm_pixel/4); % create matrix with complex walues representing source field 
    source_coord = source_setup(size(source_wave), slm_pixel/4,S_coord,k); % get coordinate system for source / wave leaving aperture A

% expander effect:
    factor = w0/expand_w; % radius changing factor of expander
    exp_wave = centered_cut(source_wave,factor.*size(source_wave));
    exp_wave = imresize(exp_wave,size(source_wave));

% crop by aperture:
    cut_wave = aperture_crop(exp_wave,source_coord,aperture); % wave behind aperture with radius 'aperture'

% propagation from the source (expander) to SLM
    slm_wave_in = propagate(cut_wave,lambda,source_coord(:,:,1),source_coord(:,:,2),-1.*source_coord(:,:,3)); % propagated wave 
    k1 = get_k1(k); % wave vector describing propagation from SLM to lens
    slm_wave_crop = imresize(crop_to_slm_size(slm_wave_in,4*slm_resolution, 4*slm_beam_center),4*slm_resolution);

% apply SLM phase changes:
    slm_wave_out = slm_wave_crop.* exp(1i*phases_change).*exp(1i*pi);
    slm_wave_out_enlarged = enlarge(slm_wave_out,lens_size); % wave with applied phase changes in larger grid

% propagate to lens (SLM -> lens)
    lc = [-lens_beam_center(1), - lens_beam_center(2), lens_d/norm(k1).*k1(3)]; % lens center coordinates
    lens_n = vector_to_vector(k1,lens_angle); % normal vector to the lens plane
    lens_coord = get_lens_coord(lens_pixel,lens_size,lc,lens_n); % tilted coordinate system for the lens

% apply effects of the lens
    lens_wave_in = propagate(slm_wave_out_enlarged,lambda,lens_coord(:,:,1),lens_coord(:,:,2),lens_coord(:,:,3));
    lens_wave_out = lens_phase_only(lens_wave_in,lens_coord(:,:,1),lens_coord(:,:,2),lambda,lens_f,lens_diam/2);
    lens_wave_out_large = enlarge(lens_wave_out, out_size);

% propagation to camera 
    cam_position = [0,0,cam_plane]; % position of camera center
    cam_norm = vector_to_vector([0,0,1],cam_angle); % vector normal to the plane of camera
    c = source_setup(size(lens_wave_out_large), slm_pixel/4,cam_position,cam_norm);
    cam_coord = c(:,:,1:3); % coordinate system for camera
    speckle_plane = propagate(lens_wave_out_large,lambda, cam_coord(:,:,1),cam_coord(:,:,2),cam_coord(:,:,3));
end