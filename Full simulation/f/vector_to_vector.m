function v = vector_to_vector(k, angle)
    k_unit = k' / norm(k);
    alpha = deg2rad(angle);
    
    v_desired = [1;0;0];
    v_cross_k = cross(v_desired, k_unit);
    v_cross_k_norm = norm(v_cross_k);
    if v_cross_k_norm ~= 0
        v_cross_k_unit = v_cross_k / v_cross_k_norm;
        cos_alpha = cos(alpha);
        sin_alpha = sin(alpha);
        R = cos_alpha*eye(3) + sin_alpha*skew(v_cross_k_unit) + (1-cos_alpha)*v_cross_k_unit*v_cross_k_unit';
    else
        R = eye(3);
    end
    
    v = R * k_unit;
    v = v/norm(v);
end
function m = skew(v)
    m = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
end