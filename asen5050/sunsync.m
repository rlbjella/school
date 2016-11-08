function sunsync_inclination = sunsync(a,e,central_radius,J2,mu,central_period,planet)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/sunsync.m
% USAGE
%   sunsync_inclination = sunsync(a,e,central_radius,J2,mu)
% DESCRIPTION
%   Computes the secular drift of the ascending node due to a central
%   bodys oblateness (J2 effect). Produces a plot of the drift versus
%   inclination and returns the inclination for drift equal to that
%   required for a sun-synchronous orbit.
% INPUTS
%   a = semimajor axis [km]
%   e = eccentricity
%   central_radius = radius of the central body [km]
%   J2 = J2 parameter of central body
%   mu = gravitational parameter of central body [km^3/s^2]
%   central_period = orbital period of the central body [days]
% OUTPUTS
%   sunsync_inclination = inclination required for sun-synchronous orbit
%   given the semimajor axis and eccentricity [deg]
%ENDHEADER

% Compute orbital parameters
p = a*(1-e^2);      % semi-parameter
T = 2*pi*sqrt(a^3/mu);  % orbital period
n = 360/T;     % mean motion
Omega_dot_sync = 360/central_period;

% Create vector of inclination values
i = linspace(0,180,1000);

% Compute drift of the ascending node
Omega_dot = -(3*n*central_radius^2*J2)/(2*p^2) * cosd(i);
% Convert to degrees per day
Omega_dot = Omega_dot * 86164.1;
% Find where the drift is closest to that for sun-sync
[M,I] = min(abs(Omega_dot - Omega_dot_sync));

% Plot drift versus inclination
figure
hold on
grid on
plot(i,Omega_dot);
plot(i,ones(length(i),1)*Omega_dot_sync,'r');
xlabel('Inclination [deg]'); ylabel('Drift of ascending node [deg/day]');
title(planet);

% Report sun-sync inclination
sunsync_inclination = i(I);
    