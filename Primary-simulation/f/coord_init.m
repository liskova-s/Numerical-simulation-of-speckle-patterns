function [X,Y,Z] = coord_init(pixels,init_size,L_coord,k)
    if abs(k(1)) <1e-10 %|| abs(L_coord(1))<1e-13
        w = [1,0,0];
    else 
        if abs(k(2)) <1e-10 
            w = [0,1,0];
        else
            w = [1;
                (-k(1)-k(3)*L_coord(3)/L_coord(1))/k(2); 
                L_coord(3)/L_coord(1)];
            w = w./norm(w);
        end
    end
    c = cross(w,k);
    c = c./norm(c);
    a = -init_size(1)/2*pixels:pixels/2:init_size(1)/2*pixels;
    a = a(2:2:end);
    b = -init_size(2)/2*pixels:pixels/2:init_size(2)/2*pixels;
    b = b(2:2:end);
      if c(3)<0
          c=-c;
      end
    [P,Q] = meshgrid(a,b);
    X = L_coord(1)+w(1)*P+c(1)*Q; % Compute the corresponding cartesian coordinates
    Y = L_coord(2)+w(2)*P+c(2)*Q; % using the two vectors in w

    if (abs(k(1)) < 1e-10 && abs(k(2)) < 1e-10)
        Z = L_coord(3)*ones(size(Y));
    else
        Z = L_coord(3)+w(3)*P+c(3)*Q;  
    end
end

