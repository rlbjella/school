function [pos_ecef] = lla2ecef(lla)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/lla2ecef.m
% USAGE
%   [pos_ecef] = lla2ecef(lla,theta_GST)
% DESCRIPTION
%   Converts latitude, longitude, and altitude into ECEF coordinates.
% INPUTS
%   lla = vector containing lat, long, and alt [deg,deg,km]
% OUTPUTS
%   pos_ecef = three element position vector in ECEF coordinates [km]
%ENDHEADER

%%% TODO %%%
% Sanitize inputs

Re = 6378.1363;     % Earth radius [km]
phi = lla(1);
lambda = lla(2);
alt = lla(3);
r = alt+Re;

x = r.*cosd(phi).*cosd(lambda);
y = r.*cosd(phi).*sind(lambda);
z = r.*sind(phi);

pos_ecef = [x y z]';

end