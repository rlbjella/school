function [a,b,c,d] = sun2diode(theta,phi)
% Given the polar and azimuthal angles of the sun vector (phi from z, theta
% from x), returns the current at each photodiode assuming unit max output
% Assumes the following configuration:
%       y           a | b
%       |           -----
%       |___x       d | c

% Convert spherical inputs to cartesian sun unit vector
x = sind(phi)*cosd(theta);
y = sind(phi)*sind(theta);
z = cosd(phi);
sun_vec = [x;y;z];

% Define unit boresight vectors for the photodiodes
avec = [-1/2; 1/2; sqrt(2)/2];
bvec = [1/2; 1/2; sqrt(2)/2];
cvec = [1/2; -1/2; sqrt(2)/2];
dvec = [-1/2; -1/2; sqrt(2)/2];

bore = [0;0;1];
theta_a_bore = acosd(dot(avec,bore)/(norm(avec)*norm(bore)));

% Compute incidence angle for each photodiode
theta_a = acosd(dot(avec,sun_vec)/(norm(avec)*norm(sun_vec)));
theta_b = acosd(dot(bvec,sun_vec)/(norm(bvec)*norm(sun_vec)));
theta_c = acosd(dot(cvec,sun_vec)/(norm(cvec)*norm(sun_vec)));
theta_d = acosd(dot(dvec,sun_vec)/(norm(dvec)*norm(sun_vec)));

% Compute current output for each photodiode
a = 1/90 * theta_a;
b = 1/90 * theta_b;
c = 1/90 * theta_c;
d = 1/90 * theta_d;

end