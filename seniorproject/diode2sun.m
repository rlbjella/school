function [x,y,sun_angle] = diode2sun(a,b,c,d)
% Given current at all four photodiodes, returns sun angle in degrees
% Assumes the following configuration:
%       y           a | b
%       |           -----
%       |___x       d | c

% Compute vector components in plane
sigma = sum([a b c d]);
x = (((b+c)-(a+d))/sigma)*45;
y = (((a+b)-(c+d))/sigma)*45;

% Compute vector component along boresight
z = sqrt(1-x^2-y^2);

% Construct sun vector
sun_vec = [x;y;z];
if (abs(norm(sun_vec)-1) > 0.00001)
    fprintf('ERROR: sun vector is not a unit vector (%f)\n',norm(sun_vec));
    sun_angle = 0;
    return
end

% Calculate angle between sun vector and boresight
boresight = [0;0;1];
sun_angle = acosd(dot(sun_vec,boresight)/(norm(sun_vec)*norm(boresight)));



end