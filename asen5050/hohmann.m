function [dv1,dv2,dv_total] = hohmann(rp1,ra1,rp2,ra2,mu,type)
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
%   mu = gravitational parameter of central body [km^3/s^2]
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

% Compute semimajor axis of both orbits
a1 = (rp1+ra1)/2;
a2 = (rp2+ra2)/2;
% Compute periapsis and apoapsis velocities for both orbits
vp1 = sqrt(2*mu/rp1 - mu/a1);
va1 = sqrt(2*mu/ra1 - mu/a1);
vp2 = sqrt(2*mu/rp2 - mu/a2);
va2 = sqrt(2*mu/ra2 - mu/a2);

% If statements to check desired type
if (strcmp(type,'aa'))
    % Burn at apoapsis to raise/lower periapsis to desired apoapsis
    at = (ra1+ra2)/2;   % transfer semimajor axis
    vt1 = sqrt(2*mu/ra1 - mu/at);
    % Compute delta-V for first impulse burn
    dv1 = abs(vt1 - va1);
    vt2 = sqrt(2*mu/ra2 - mu/at);   % velocity at point of second burn on transfer
    % Compute delta-V for second impulse burn
    dv2 = abs(vt2 - va2);
    % Compute total delta-V
    dv_total = dv1 + dv2;
    
elseif (strcmp(type,'ap'))
    % Burn at apoapsis to raise/lower periapsis to new periapsis
    at = (ra1+rp2)/2;   % transfer semimajor axis
    vt1 = sqrt(2*mu/ra1 - mu/at);
    % Compute delta-V for first impulse burn
    dv1 = abs(vt1 - va1);
    vt2 = sqrt(2*mu/rp2 - mu/at);
    % Compute delta-V for second impulse burn
    dv2 = abs(vt2 - vp2);
    % Compute total delta-V
    dv_total = dv1 + dv2;
    
elseif (strcmp(type,'pa'))
    % Burn at periapsis to raise/lower apoapsis to new apoapsis
    at = (rp1+ra2)/2;
    vt1 = sqrt(2*mu/rp1 - mu/at);
    % Compute delta-V for first impulse burn
    dv1 = abs(vt1 - vp1);
    vt2 = sqrt(2*mu/ra2 - mu/at);
    % Compute delta-V for second impulse burn
    dv2 = abs(vt2 - va2);
    % Compute total delta-V
    dv_total = dv1 + dv2;
    
elseif (strcmp(type,'pp'))
    % Burn at periapsis to raise/lower periapsis to new periapsis
    at = (rp1+rp2)/2;
    vt1 = sqrt(2*mu/rp1 - mu/at);
    % Compute delta-V for first impulse burn
    dv1 = abs(vt1 - vp1);
    vt2 = sqrt(2*mu/rp2 - mu/at);
    % Compute delta-V for second impulse burn
    dv2 = abs(vt2 - vp2);
    % Compute total delta-V
    dv_total = dv1 + dv2;
    
else
    % Bad type input
    fprintf('ERROR: acceptable transfer types are aa, ap, pa, and pp\n');
    dv1 = 0; dv2 = 0; dv_total = 0;
    return
end

end