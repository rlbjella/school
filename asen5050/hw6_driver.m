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
i = 51.6441;
Omega = 225.6859;
e = 0.0006691;
omega = 42.3347;
n = 0.0647521665;
P = 360/n;
mu = 398600.44;
a = 6783.0468;
M1 = 271.7208;     % Oct 11-01:00:00 UTC
theta1 = 35.097736;
omega_E = 4.178074622e-3;

% Boulder tracking station data
latB = 40.01;
lonB = 254.83;
altB = 1615/1000; %km
inview = 0; %flag to indicate if ISS is in view of Boulder

% Create three hour time array
time = (0:180)*60;  % seconds
lat = zeros(length(time),1);
lon = zeros(length(time),1);
true = zeros(length(time),1);
% Create array for first pass data
pass = zeros(length(time),3);
% Compute all anomalies for the time period
% Then, compute ECEF and LLA positions
for k = 1:length(time)
    % Compute anomalies
    mean = M1 + n*time(k);
    [true(k),ecc,mean,t_p,r] = anomalies(mean,'mean',a,e,mu,1);
    % Compute ECI position
    [Rijk,Vijk] = coe2state(a,e,i,Omega,omega,true(k),mu);
    % Compute Greenwich sidereal time and ECEF position
    theta = mod(theta1+omega_E*time(k),360);
    pos_ecef = eci2ecef(Rijk, theta);
    % Compute LLA
    [lat(k),lon(k),~] = ecef2lla(pos_ecef);
    
    % Compute overhead passes of Boulder
    pos_topo = ecef2topo(pos_ecef,latB,lonB,altB);
    az = pos_topo(1);
    el = pos_topo(2);
    range = pos_topo(3);
    if (el >= 0 && inview == 0) % not currently in pass elevation above horizon
        inview = 1;
        fprintf('OVERHEAD PASS\n');
        fprintf('Time since epoch: %f\n',time(k));
        pass(k,1) = time(k);
        pass(k,2) = az;
        pass(k,3) = el;
    elseif (el >= 0 && inview == 1)
        pass(k,1) = time(k);
        pass(k,2) = az;
        pass(k,3) = el;
    elseif (el < 0 && inview == 1)
        inview = 0;
        fprintf('OVERHEAD PASS ENDED\n');
        fprintf('Time since epoch: %f\n',time(k));
    end
end

% Plot latitude and longitude
figure
hold on
grid on
plot(worldmap2384(:,1),worldmap2384(:,2),'r')
plot(lon,lat,'*')
title('ISS Groundtrack starting Oct. 11, 2016 at 01:00:00')

% Plot Boulder pass data
pass_times = pass(28:37,1);
az = pass(28:37,2);
el = 90 - pass(28:37,3);
figure
hold on
grid on
plot(az,el)
title('Zenith angle vs azimuth for Boulder pass')
xlabel('Azimuth [deg]')
ylabel('Zenith angle [deg]')

