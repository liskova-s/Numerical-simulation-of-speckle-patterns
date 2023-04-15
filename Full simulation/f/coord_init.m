function [X,Y,Z] = coord_init(pix_size,net_size,center,n)
    % pix_size  size of pixels
    % net_size  size of modeled net in pixels
    % center    coordinates of center of the net
    % n         normal vector to the plane
    
    % Check input parameters for validity
    if isempty(pix_size) || isnan(pix_size) || ...
            isempty(net_size) || any(isnan(net_size)) || ...
            isempty(center) || any(isnan(center)) || ...
            isempty(n) || any(isnan(n))
        error('Invalid input parameter(s)');
    end
    
    % Check for division by zero in calculation of w(2)
    if abs(n(1)) < 1e-10 || abs(center(1)) < 1e-13
        w = [1,0,0];
    elseif abs(n(2)) < 1e-10 
        w = [0,1,0];
    else
        w = [1;
             (-n(1)-n(3)*center(3)/center(1))/n(2); 
              center(3)/center(1)];
        wdot = dot(w,w);
        if wdot < 0 || isnan(wdot)
            error('Invalid input parameter(s)');
        end
        w = w./sqrt(wdot);
    end
    
    % Check for division by zero in calculation of c
    c = cross(w,n);
    cdot = dot(c,c);
    if cdot < 0 || isnan(cdot)
        error('Invalid input parameter(s)');
    end
    c = c./sqrt(cdot);
    
    % Check for invalid input to meshgrid
    a = -net_size(1)/2*pix_size:pix_size/2:net_size(1)/2*pix_size;
    a = a(2:2:end);
    b = -net_size(2)/2*pix_size:pix_size/2:net_size(2)/2*pix_size;
    b = b(2:2:end);
      if c(3)<0
          c=-c;
      end
    [P,Q] = meshgrid(a,b);
    X = center(1)+w(1)*P+c(1)*Q; % Compute the corresponding cartesian coordinates
    Y = center(2)+w(2)*P+c(2)*Q; % using the two vectors in w

    if (abs(n(1)) < 1e-10 && abs(n(2)) < 1e-10)
        Z = center(3)*ones(size(Y));
    else
        Z = center(3)+w(3)*P+c(3)*Q;  
    end
end

