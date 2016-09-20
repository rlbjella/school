function [Rijk,Vijk] = coe2state(semimajor,ecc,inc,raan,arg_peri,true,mu)
%BEGINHEADER
% SOURCE
%   coe2state.m
% USAGE
%   [Rijk,Vijk] = coe2state(semimajor,ecc,inc,raan,arg_peri,true,mu)
% DESCRIPTION
%   Given the classical orbital elements of a satellite, returns the
%   position and velocity vectors in ECI coordinates.
% INPUTS
%   semimajor = semimajor axis [km]
%   ecc = eccentricity
%   inc = inclination [deg]
%   raan = right ascension of the ascending node [deg]
%   arg_peri = argument of periapsis [deg]
%   true = true anomaly [deg]
%   mu = gravitational parameter of central body [km^3/s^2]
% OUTPUTS
%   Rijk = three-dimensional position vector [km]
%   Vijk = three-dimensional velocity vector [km/s]
%ENDHEADER

% Check inputs and adjust for special cases
if (ecc == 0 && inc == 0)   % Circular equatorial
    raan = 0;
    arg_peri = 0
end
if (ecc == 0 && inc ~= 0)   % Circular inclined
    arg_peri = 0;
end
if (ecc ~= 0 && inc == 0)   % Elliptical equatorial
    raan = 0;
end
if (ecc >= 1)
    printf('ERROR: function only supports circular or eccentric orbits.\n');
end

% Earth radius
%%%%%%%% TODO %%%%%%%%%
% Add support for altitude above other central bodies
RE = 6378;      % [km]
period = 2*pi*sqrt(semimajor^3/mu);
energy = -mu/(2*semimajor);
p = semimajor*(1-ecc^2);

% Get position and velocity vectors in perifocal coordinates
Rpqw = [p*cosd(true)/(1+ecc*cosd(true));...
    p*sind(true)/(1+ecc*cosd(true));...
    0];
Vpqw = [-sqrt(mu/p)*sind(true);...
    sqrt(mu/p)*(ecc+cosd(true));...
    0];
    
% Construct transformation matrix
R3_W = [cosd(raan) sind(raan) 0;
        -sind(raan) cosd(raan) 0;
        0 0 1];
R1_i = [1 0 0;
        0 cosd(inc) sind(inc);
        0 -sind(inc) cosd(inc)];
R3_w = [cosd(arg_peri) sind(arg_peri) 0 
        -sind(arg_peri) cosd(arg_peri) 0
        0 0 1];
pqw2ijk = (R3_w*R1_i*R3_W)';

% Calculate output vectors
Rijk = pqw2ijk*Rpqw;
Vijk = pqw2ijk*Vpqw;

end