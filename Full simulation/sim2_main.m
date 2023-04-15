clear;
clc;
% This script manages the setup parameters (see scheme in Readme for
% reference) and runs a calculation of speckle pattern in distance
% 'cam_plane' from the lens executed by sim2_generate_speckles() function.

% PARAMETERS:
slm_angle = 0;                  % [deg] incident angle on SLM (alpha)
slm_beam_center = [540,960];    % [px] coordinates of pixel where the beam center is incident, see readme file 
aperture = 0.00265;              % [m] radius of aperture behind the expander 
lens_angle = 0;                 % [deg] incident angle on the lens (beta) 
lens_beam_center = [0,0];       % [mm] x,y distance of the beam center from the center of the lens 
crosstalk_sigma = 2;            % sigma of Gaussian filter used to model pixel crosstalk
cam_angle = 0;                  % [deg] incident angle on the camera (gamma)
cam_plane = 0.1;             % [m] distance of observed plane from the lens
phase_mask = cell2mat(struct2cell(load('phase_mask_rough.mat')));  % 1080x1920 matrix with real values 0 - 2pi

% EVALUATION
speckle_plane = sim2_generate_speckles(slm_angle,slm_beam_center,aperture,lens_angle,lens_beam_center,crosstalk_sigma,cam_angle,cam_plane,phase_mask);

% VISUALISATION
figure()
subplot 211
imagesc(phase_mask)
title('Applied phase mask')
subplot 212
imagesc(abs(speckle_plane))
title('Amplitudes of speckle pattern')