function [lat,lon,alt] = ecef2lla(ecef)
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
%   lat = geocentric latitude [deg]
%   lon = longitude [deg]
%   alt = altitude above Earth surface [km]
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
lat = rad2deg(phi);
lon = rad2deg(lambda);
alt = h;

end
