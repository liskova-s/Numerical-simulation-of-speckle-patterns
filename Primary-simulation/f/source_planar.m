function source_planar = source_planar(k1, L_coord, slm_resolution, slm_pixel,coords)
        sigma = [0.005,0.005];
        % source plane: k1*x +k2*y + k3*z + d = 0
        init_size = slm_resolution.*2;
        plane = ones(slm_resolution*2);
        gaussian_plane = plane.* exp(-((coords(:,:,1)).^2./(2.*sigma(1).^2)+(coords(:,:,2)).^2./(2.*sigma(2).^2)));
     
        [x,y,z] = SLM_functions.coord_init(slm_pixel, init_size, L_coord, k1);
        xlabel('X')
        ylabel('Y')
        zlabel('Z')
        source_planar = -x';
        source_planar(:,:,2)=-y';
        source_planar(:,:,3)=-z';
        source_planar(:,:,4)=gaussian_plane;
    end
   
 