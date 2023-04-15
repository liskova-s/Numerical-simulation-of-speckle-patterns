clear;
clc;
% This script manages the setup parameters (see scheme in Readme for
% reference) and runs a calculation of speckle pattern in distance
% 'cam_plane' from the lens executed by sim1_generate_speckles() function.

% PARAMETERS:
cam_plane = 0.1; % [m] distance of observed plane from the lens
phase_mask = cell2mat(struct2cell(load('example_phase_mask.mat')));  % 1080x1920 matrix with real values 0 - 2pi

% EVALUATION
speckle_plane = sim1_generate_speckles(cam_plane,phase_mask);

% VISUALISATION
figure()
subplot 211
imagesc(phase_mask)
title('Applied phase mask')
subplot 212
imagesc(abs(speckle_plane))
title('Amplitudes of speckle pattern')