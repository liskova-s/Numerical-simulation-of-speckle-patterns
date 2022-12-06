function coords = SLM_coords(slm_resolution,slm_pixel)
    x_coords = zeros(slm_resolution);
    y_coords = zeros(slm_resolution);
    for i = 1:slm_resolution(1)
        for j = 1:slm_resolution(2)
            [x,y] = pixel_to_coord(i,j,slm_pixel,slm_resolution);
            x_coords(i,j) = x;
            y_coords(i,j) = y;
        end
    end
    coords(:,:,1) = x_coords;
    coords(:,:,2) = y_coords;
end

