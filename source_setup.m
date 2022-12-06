function source = source_setup(slm_resolution, lambda, P, w0,z,slm_pixel,L_coord,k)
        init_size = slm_resolution;
        plane = ones(slm_resolution);
        U = gaussian_beam(lambda,P,w0,z,slm_resolution,slm_pixel);
        [x,y,z] = coord_init(slm_pixel, init_size, L_coord, k);
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        source = -x';
        source(:,:,2)=-y';
        source(:,:,3)=-z';
        source(:,:,4) = U;
    end
   
 