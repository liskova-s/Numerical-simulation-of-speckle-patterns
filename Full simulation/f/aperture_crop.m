function cut_wave = aperture_crop(exp_wave,source_coord,aperture)
 P = ones(size(exp_wave));
 Rsq = source_coord(:,:,1).^2+source_coord(:,:,2).^2;
 P(Rsq>4*aperture^2) = 0; 
 cut_wave = abs(exp_wave.*P); % wave behind aperture with radius 'aperture'
end