function [cx,cy] = pixel_to_coord(pxx,pxy,slm_pixel,slm_resolution)
    % returns the coordinates of center of given pixel
    x1 = slm_resolution(1)/2*slm_pixel-slm_pixel/2;
    y1 = -slm_resolution(2)/2*slm_pixel + slm_pixel/2;
    cx = -(pxx-1)*slm_pixel+x1;
    cy = (pxy-1)*slm_pixel + y1;
end
