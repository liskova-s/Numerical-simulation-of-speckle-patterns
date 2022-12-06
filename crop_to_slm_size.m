 function cropped = crop_to_slm_size(wave,slm_resolution, beam_center,x_coords,y_coords,z_coords)
        % phi: phase of source
        % source plane: x,y,z coords
        middle_pixel = slm_resolution/2; % reference middle pixel of slm plane
        shift =  beam_center- middle_pixel-1;
        c = slm_resolution/2-shift;
        %c = middle_pixel+1;
        source_croppedx = (x_coords(c(1):c(1)+slm_resolution(1)-1,c(2):c(2)+slm_resolution(2)-1));  % segment of source plane corresponding to slm size, aligned that pixels correnspond
        source_croppedy = (y_coords(c(1):c(1)+slm_resolution(1)-1,c(2):c(2)+slm_resolution(2)-1));
        source_croppedz = (z_coords(c(1):c(1)+slm_resolution(1)-1,c(2):c(2)+slm_resolution(2)-1));
        amplitudes = wave(c(1):c(1)+slm_resolution(1)-1,c(2):c(2)+slm_resolution(2)-1);
        cropped = source_croppedx;
        cropped(:,:,2) = source_croppedy;
        cropped(:,:,3) = source_croppedz;
        cropped(:,:,4) = amplitudes;
    %     figure()
    %     subplot 211
    %     imagesc(real(wave))
    %     title('Wave at slm before cropping')
    %     subplot 212
    %     imagesc(real(amplitudes))
    %     title('Cropped to the size of SLM')
    end