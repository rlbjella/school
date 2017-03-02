function [pos_eci] = ecef2eci(pos_ecef,theta_GST)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/ecef2eci.m
% USAGE
%   [pos_eci] = ecef2eci(pos_ecef,theta_GST)
% DESCRIPTION
%   Converts a three element displacement vector in ECEF coordinates to
%   inertial ECI coordinates for a given Greenwich Sidereal Time.
% INPUTS
%   pos_ecef = three element position vector in ECEF coordinates [km]
%   theta_GST = Greenwich Sidereal Time [deg]
% OUTPUTS
%   pos_eci = three element position vector in ECI coordinates [km]
%ENDHEADER

% Sanitize inputs
if (length(pos_ecef) ~= 3)
    fprintf('ERROR: ECEF position vector should have three elements\n');
    pos_eci = [0 0 0]';
    return
end

% Construct transformation matrix
x = deg2rad(theta_GST);  % brevity
rot3 = [cos(-x) sin(-x) 0;-sin(-x) cos(-x) 0;0 0 1];

% Compute ECEF position
pos_eci = rot3*pos_ecef;

end