function [x,y,z]= source_c(norm,theta)
theta_rad = theta * pi / 180;

r = norm;
phi = 0; 
theta_sph = theta_rad;
[z_sph, y_sph, x_sph] = sph2cart(phi, theta_sph, r);

x = x_sph;
y = y_sph;
z = z_sph;
end

