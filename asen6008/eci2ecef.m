function [pos_ecef] = eci2ecef(pos_eci, theta_GST)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/eci2ecef.m
% USAGE
%   [pos_ecef] = eci2ecef(pos_eci, theta_GST)
% DESCRIPTION
%   Given a position vector in ECI inertial coordinates and the Greenwich
%   Sidereal Time, computes the position vector in Earth-fixed ECEF
%   coordinates.
% INPUTS
%   pos_eci = three element displacement vector in ECI coordinates [km]
%   theta_GST = Greenwich Sidereal Time [deg]
% OUTPUTS
%   pos_ecef = three element displacement vector in ECEF coordinates [km]
%ENDHEADER

% Sanitize inputs
if (length(pos_eci) ~= 3)
    fprintf('ERROR: ECI position vector should have three elements\n');
    pos_ecef = [0 0 0]';
    return
end

% Construct transformation matrix
x = deg2rad(theta_GST);  % brevity, use rads
rot3 = [cos(x) sin(x) 0;-sin(x) cos(x) 0;0 0 1];

% Compute ECEF position
pos_ecef = rot3*pos_eci;

end