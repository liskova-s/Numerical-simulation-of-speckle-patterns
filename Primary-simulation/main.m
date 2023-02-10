clear all;
clc;
tic;
%% PARAMETERS AND SETUP
addpath('.\f');

% PLUTO SLM 
    slm_resolution = [1080,1920];               % SLM resolution [pixels]
    slm_pixel = 8*10^(-6);                      % pixel size: 8 um x 8um in [m]
    beam_center = [540,960];                    % coordinates of estimated beam center in pixels (pixels are being counted from upper left corner)

% LASER (He-Ne)____________________________________________________________
    lambda = 632.8*10^(-9);                     % laser wavelength [m]  
    P = 0.001;                                  % laser power[W]
    w0 = 2e-3;                                  % beam waist width [m]
    z0 = pi*w0^2/lambda;                        % beam waist z position 
    dist = 0.2;                                 % distance laser source - center of SLM in [m]
    L_coord = [0,0, dist];                      % laser source distance coordinates [m]
    w_exp = w0;                                 % initial laser beam diameter
    z = z0;                                     % z = z0*((w_exp/w0)^2 - 1)^(1/2);

% LENS
    lens_z = 1;                                 % z  position of lens (distance form SLM)[m]
    lens_size = [8000,8000];                    % coordinate grid for the lens [pixels]
    lens_diam = 0.015;                          % aperture diameter [m]
    lens_pixel = 8*10^(-6)/4;                   % pixel size [m]
    lens_f = 0.1;                               % focal distance of lens [m]

% MIRROR
    mirror_z = 0.5;                             % [m]

%SLM
    % phase change using QR-code-like structure 
    p_change = cell2mat(struct2cell(load('qr_mask_slm.mat')));
    p_change = pi*p_change(1:400,1:500);
    p_change = imresize(p_change, slm_resolution*4);
    % different phase change implementations are provided in
    % 'phase_changes.m' file
  
% VISUALISATION
    % near-focus plane cut:
    z_plane = 1e-3;                                 % z distance of the plane of observation from the focus of lens

%% PROCESSING
    disp('Setting up source and coordinates...');
    % setup:
    [source_coord, source_wave , slm_coord, mirror_coord, lens_coord] = setup(L_coord,beam_center,lambda,slm_pixel,slm_resolution,lens_size, lens_pixel,P,w0,z0,z);
    disp('Source -> SLM propagation...');
    % propagation from the source (expander) to SLM
    slm_wave_in = propagate(source_wave,lambda,source_coord(:,:,1),source_coord(:,:,2),source_coord(:,:,3));
    slm_wave_out = slm_wave_in;
    disp('Applying phase changes...');
    % apply SLM phase changes:
    slm_wave_out = slm_wave_out.* exp(1i*p_change).*exp(1i*pi);
    disp('SLM -> Mirror propagation...');
    % propagate to mirror (SLM -> mirror)
    slm_wave_out_enlarged = enlarge(slm_wave_out,lens_size);
    mirror_wave_in = propagate(slm_wave_out_enlarged,lambda,mirror_coord(:,:,1),mirror_coord(:,:,2),mirror_z*ones(size(slm_wave_out_enlarged)));

    % apply mirror phase change
    mirror_wave_out = mirror_wave_in .* exp(1i*pi*ones(lens_size));
    disp('Mirror -> Lens propagation...');
    % propagate to lens (mirror -> lens)
    lens_wave_in = propagate(mirror_wave_out,lambda,lens_coord(:,:,1),lens_coord(:,:,2),(lens_z-mirror_z)*ones(size(mirror_wave_out)));
    lens_wave_out = lens_phase_only(lens_wave_in,lens_coord(:,:,1),lens_coord(:,:,2),lambda,lens_f,lens_diam/2);
     
    disp('Lens -> Focus and Lens -> Desired plane propagations...');
    % Propagate to focus and desired z plane
    focus_plane_o  = propagate(lens_wave_out,lambda,lens_coord(:,:,1),lens_coord(:,:,2), lens_f);
    plane_o = propagate(lens_wave_out,lambda,lens_coord(:,:,1),lens_coord(:,:,2), lens_f+z_plane);
    plane = abs(plane_o) - mean(abs(plane_o),'all');
    plane = crop_speckles(plane, [2000,2400]); 
    focus = abs(focus_plane_o) - mean(abs(focus_plane_o),'all');
    focus = crop_speckles(focus, [2000,2400]);
    c = corr2(abs(plane),abs(focus));
    
%% Visualisation
    figure()
subplot 311
imagesc(p_change);
title('Used phase mask')

subplot 312
imagesc(abs(focus_plane_o));
title('Focal plane pattern')

subplot 313
imagesc(abs(plane_o));
title(sprintf('Pattern in observed plane %.2f mm from focus \n Correlation degree: %.3f',z_plane*1e3,c))

  
% command line prompts 
% set(gca, 'XTick',0:10:100, 'XTickLabel',x)
% hgsave(2, 'E:\MATLAB\Sarka_Liskova\simI\correlated_1_meansubtracted.fig', '-v7.3');    

toc;

function m = crop_speckles(matrix, resolution)
    [x,y] = size(matrix);
    cols = mean(matrix);
    rows = mean(matrix, 2);
    Y1 = 0;
    X1 = 0;
    Y2=5000;
    X2=5000;
    for i = 1:y/2
        if cols(i) > 0 && Y1 == 0
            Y1 = i; 
            break;
        end
    end
    for i=y/2:y
        if cols(i) < 0 && Y1 ~= 0
            Y2 = i;
            break;
        end 
    end
    
    for i = 1:x/2
        if rows(i) > 0 && X1 == 0
            X1 = i;
            break;
        end
    end
    for i = x/2:x
        if rows(i) < 0 && X1 ~= 0
            X2 = i;
            break;
        end 
    end
    m = matrix(X1:X2,Y1:Y2);
    m = imresize(m,resolution);
end




