 function cropped = crop_to_slm_size(wave, slm_resolution,beam_center,sx_coords,sy_coords,sz_coords)
 % Returns source wave cropped to the size of SLM respecting beam_center as pixel where the middle of
 % beam is incident
        % source plane: x,y,z coords
        sc = size(wave)/2;                          % reference middle pixel of source wave net
        leftupper = sc - beam_center +[1,1];        % left upper corner of cutout
        rightlower = leftupper+slm_resolution;      %right lower corner of cutout
        
%         cropped = sx_coords(leftupper(1):rightlower(1),leftupper(2):rightlower(2));  % segment of source plane corresponding to slm size, aligned that pixels correnspond
%         cropped(:,:,2) = sy_coords(leftupper(1):rightlower(1),leftupper(2):rightlower(2));
%         cropped(:,:,3) = sz_coords(leftupper(1):rightlower(1),leftupper(2):rightlower(2));
        cropped = wave(leftupper(1):rightlower(1),leftupper(2):rightlower(2)); % amplitudes
end