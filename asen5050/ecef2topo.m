function [pos_topo] = ecef2topo(pos_ecef,lat,lon,alt)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/ecef2topo.m
% USAGE
%   [pos_topo] = ecef2topo(pos_ecef,lat,lon,alt)
% DESCRIPTION
%   Given an ECEF position vector of a satellite and the latitude,
%   longitude, and altitude of a tracking station, computes the azimuth,
%   elevation, and range of the satellite from that station.
% INPUTS
%   pos_ecef = ECEF position vector of satellite [km]
%   lat = latitude of ground station [deg]
%   lon = longitude of ground station [deg]
%   alt = altitude of ground station [km]
% OUTPUTS
%   pos_topo = vector containing azimuth, elevation, and range of satellite
%   [deg,deg,km]
%ENDHEADER

% Get ECEF position vector of ground station
lla = [lat lon alt]';
gnd = lla2ecef(lla);

% Get relative position vector of satellite
rho_ecef = pos_ecef-gnd;

% Define rotation matrices
x = deg2rad(90 - lat);   % brevity
rot2 = [cos(x) 0 -sin(x);0 1 0;sin(x) 0 cos(x)];
y = deg2rad(lon);   % brevity
rot3 = [cos(y) sin(y) 0;-sin(y) cos(y) 0;0 0 1];

% Convert to SEZ
sez = rot2*rot3*rho_ecef;
sez_mag = norm(sez);    % magnitude of position vector [km]

% Compute elevation
el = asind(sez(3)/sez_mag);
% Compute azimuth with quadrant check
sin_az = sez(2) / sqrt(sez(1)^2+sez(2)^2);
cos_az = -sez(2) / sqrt(sez(1)^2+sez(2)^2);

end