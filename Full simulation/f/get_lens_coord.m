function lens_coord = get_lens_coord(lens_pixel,lens_size,lc,lens_n)
[x,y,z] = coord_init_cam(lens_pixel,lens_size,lc,lens_n); 
lens_coord(:,:,1) = -x';
lens_coord(:,:,2)=-y';
lens_coord(:,:,3)=-z';
end