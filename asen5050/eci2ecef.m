function [pos_ecef,lla] = eci2ecef(pos_eci, theta_GST)
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
%   lla = latitude, longitude, and altitude [deg,deg,km]
%ENDHEADER

% Sanitize inputs
if (length(pos_eci) != 3)
    fprintf('ERROR: ECI position vector should have three elements\n');
    pos_ecef = [0 0 0]';
    return
end

end