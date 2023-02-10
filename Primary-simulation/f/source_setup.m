function source = source_setup(slm_resolution,slm_pixel,L_coord,k)
        init_size = slm_resolution;
        [x,y,z] = coord_init(slm_pixel, init_size, L_coord, k);
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        source = -x';
        source(:,:,2)=-y';
        source(:,:,3)=-z';
    end
   
 