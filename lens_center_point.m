function lc = lens_center_point(k,z, c1,c2)
        % assuming the lens is perfectly vertically oriented
        t = z/k(3);
        x = c1 + t*k(1);
        y = c2 + t*k(2);
        lc = [x,y,z];
    end
