function [true,mean,eccentric] = time2anomaly(time,semimajor,ecc,mu)
%BEGINHEADER
% SOURCE
%   time2anomaly.m
% USAGE
%   [true,mean,eccentric] = time2anomaly(time,semimajor,ecc,mu)
% DESCRIPTION
%   Given time past periapsis, semimajor axis, eccentricity, and the
%   gravitational parameter of the central body, return all three anomalies
%   (true, mean, and eccentric).
% INPUTS
%   time = time past periapsis [s]
%   semimajor = semimajor axis [km]
%   ecc = eccentricity
%   mu = gravitational parameter of central body [km^3/s^2]
% OUTPUTS
%   true = true anomaly [deg]
%   mean = mean anomaly [deg]
%   eccentric = eccentric anomaly [deg]
%ENDHEADER

% Check inputs
if (ecc >= 1)
    printf('ERROR: function only supports circular and elliptical orbits.\n');
end

% Calculate required constants
period = 2*pi*sqrt(semimajor^3/mu);
n = 2*pi/period;    % mean motion

% Mean and eccentric anomalies (1/100,000 degree tolerance on eccentric
mean = time*n;
eccentric = eccentric_anomaly(deg2rad(mean),ecc,0.00001);

% Compute true anomaly using atan2
sinv = sin(eccentric)*sqrt(1-ecc^2)/(1-ecc*cos(eccentric));
cosv = (cos(eccentric)-ecc)/(1-ecc*cos(eccentric));
true_rad = atan2(sinv,cosv);
true = rad2deg(true_rad);


end

