function xdot = two_body(t,X)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/two_body.m
% USAGE
%   xdot = two_body(t,X)
% DESCRIPTION
%   Two body integrating function for use with ode45.
% INPUTS
%   t = time array [s]
%   X = initial conditions vector
% OUTPUTS
%   xdot = derivatives of all six degrees of freedom in IC vector
%ENDHEADER

mu = 398600.4415; %gravitational parameter for Earth [km^3/s^2]
r = norm(X(1:3));

xdot = [X(4);X(5);X(6);-mu*X(1)/(r^3);-mu*X(2)/(r^3);-mu*X(3)/(r^3)];

end