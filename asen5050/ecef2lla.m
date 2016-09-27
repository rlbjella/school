function [lla] = ecef2lla(ecef)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/ecef2lla.m
% USAGE
%   [lla] = ecef2lla(ecef)
% DESCRIPTION
%   Converts an ECEF position vector to latitude, longtitude, and altitude
% INPUTS
%   ecef = ECEF position vector [km]
% OUTPUTS
%   lla = latitude, longitude, and altitude [deg,deg,km]
%ENDHEADER

% Compute distance vector to ecef position
r = norm(ecef);
% Seperate ecef into components
x = ecef(1);
y = ecef(2);
z = ecef(3);

% Compute longitude
lambda = atan2(y,x);
% Compute latitude
phi = asin(z/r);
% Compute altitude
h = r - 6378.1363;

% Construct output
lla = [rad2deg(phi) rad2deg(lambda) h]';

end
