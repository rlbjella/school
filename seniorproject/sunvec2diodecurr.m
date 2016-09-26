function [ai,bi,ci,di] = sunvec2diodecurr(sun)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Constants
Imax = 1;   % max current output of one diode, A


% Define photodiode normal vectors 
a_norm = [1;0;-1];
b_norm = [1;-1;0];
c_norm = [1;0;1];
d_norm = [1;1;0];

% Calculate angle between each normal vector and sun vector
a_theta = atan2(norm(cross(a_norm,sun)),dot(a_norm,sun));
b_theta = atan2(norm(cross(b_norm,sun)),dot(b_norm,sun));
c_theta = atan2(norm(cross(c_norm,sun)),dot(c_norm,sun));
d_theta = atan2(norm(cross(d_norm,sun)),dot(d_norm,sun));

% Calculate photodiode output current
ai = Imax*cos(a_theta);
bi = Imax*cos(b_theta);
ci = Imax*cos(c_theta);
di = Imax*cos(d_theta);

end

