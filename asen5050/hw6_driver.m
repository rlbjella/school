%BEGINHEADER
% SOURCE
%   /mnt/c/Users/Russell/repos/school/asen5050/hw6_driver.m
% USAGE
%   hw6_driver
% DESCRIPTION
%   Driver script for groundtrack assignment.
% INPUTS
%   N/A
% OUTPUTS
%   N/A
%ENDHEADER

% Housekeeping
clear all
close all
clc

% Load map data
load worldmap2384.dat

% Orbital parameters and constants
i = 51.6190;
Omega = 13.334;
e = 0.0005770;
omega = 102.5680;
n = 0.06496308625;
P = 5541.608639;
mu = 398600.44;
a = 6768.35683;
M1 = 199.30011;     % Oct 11-01:00:00 UTC
theta1 = 35.097736;
omega_E = 4.178074622e-3;

% Create three hour time array
time = (0:180)*60;  % seconds
lat = zeros(length(time),1);
lon = zeros(length(time),1);
true = zeros(length(time),1);
% Compute all anomalies for the time period
% Then, compute ECEF and LLA positions
for i = 1:length(time)
    % Compute anomalies
    [true(i),mean,ecc] = time2anomaly(time(i),a,e,mu);
    % Compute ECI position
    [Rijk,Vijk] = coe2state(a,e,i,Omega,omega,true(i),mu);
    % Compute Greenwich sidereal time and ECEF position
    theta = mod(theta1+omega_E*time(i),360);
    pos_ecef = eci2ecef(Rijk, theta);
    % Compute LLA
    lla = ecef2lla(pos_ecef);
    lat(i) = lla(1);
    lon(i) = lla(2);
end

% Plot latitude and longitude
worldmap world
load coastlines
plotm(coastlat,coastlon)
plotm(lat,lon,'r')