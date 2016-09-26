function [dv1,dv2,dv_total] = hohmann(rp1,ra1,rp2,ra2,type)
%BEGINHEADER
% SOURCE
%   /c/repos/school/asen5050/hohmann.m
% USAGE
%   [dv1,dv2,dv_total] = hohmann(rp1,ra1,rp2,ra2,type)
% DESCRIPTION
%   Given an initial orbits radius of periapsis and apoapsis and a target
%   orbits periapsis and apoapsis, as well as the type of transfer
%   (peri-peri, apo-apo, peri-apo, etc.), computes the delta-V for each of
%   the two impulse burns as well as the total delta-V
% INPUTS
%   rp1 = initial radius of periapsis [km]
%   ra1 = initial radius of apoapsis [km]
%   rp2 = target radius of periapsis [km]
%   ra2 = target radius of apoapsis [km]
%   type = string indicating type of transfer desired
%       'aa' = burn at initial apoapsis and target apoapsis
%       'ap' = burn at initial apoapsis and target periapsis
%       'pa' = burn at initial periapsis and target apoapsis
%       'pp' = burn at initial periapsis and target apoapsis
% OUTPUTS
%   dv1 = delta-V for first impulse burn [km/s]
%   dv2 = delta-V for second impulse burn [km/s]
%   dv_total = sum of dv1 and dv2 [km/s]
%ENDHEADER

% Sanitize inputs
if (rp1 < 0 || ra1 < 0 || rp2 < 0 || ra2 < 0)
    fprintf('ERROR: radiuses of apoapsis and periapsis must be positive\n)');
    dv1 = 0; dv2 = 0; dv_total = 0;
    return
end
type = lower(strtrim(type));

%%% TODO %%%
% Add "optimal" keyword to type options to automatically select transfer
% type with smallest total delta-V. Compare apoapsis/periapsis radii and
% assign type.

% If statements to check desired type
if (strcmp(type,'aa'))
    % Apo-apo
elseif (strcmp(type,'ap'))
    % Apo-peri
elseif (strcmp(type,'pa'))
    % Peri-apo
elseif (strcmp(type,'pp'))
    % Peri-peri
else
    % Bad type input
    fprintf('ERROR: acceptable transfer types are aa, ap, pa, and pp\n');
    dv1 = 0; dv2 = 0; dv_total = 0;
    return
end

end