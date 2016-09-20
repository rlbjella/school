% Russell Bjella
% ASEN 5050
% September 20, 2016
% Homework 3

clear all
close all
clc

%% Problem 1
R = [-5633.9;-2644.9;2834.4];   % km
V = [2.425;-7.103;-1.8];    % km/s
mu = 398600.44; %km^3/s^2
elements = state2orbit(R,V,mu,0);
fprintf('a,e,i,Omega,omega,true=\n');
disp(elements.a);
disp(elements.e);
disp(rad2deg(elements.i));
disp(rad2deg(elements.raan));
disp(rad2deg(elements.omega));
disp(rad2deg(elements.true));

%% Problem 2 and 3
% Problem 2
mu = 398600.44;
% From TLE:
i = 51.6396;
raan = 342.1053;
e = 0.0008148;
omega = 106.9025;
mean = 257.5950;
% Convert mean anomaly to eccentric and true anomalies
eccentric = eccentric_anomaly(deg2rad(mean),e,0.00001);
sinv = sin(eccentric)*sqrt(1-e^2)/(1-e*cos(eccentric));
cosv = (cos(eccentric)-e)/(1-e*cos(eccentric));
true_rad = atan2(sinv,cosv);
true = rad2deg(true_rad);
% Convert mean motion from rev/day to rad/s to semimajor axis
n = 15.59182721*(2*pi)/86164.1; % rad/s
period = 2*pi/n;
a = ((period/(2*pi))^2 * mu)^(1/3);
% Convert COE to state vector
[Rijk,Vijk] = coe2state(a,e,i,raan,omega,true,mu);
disp(Rijk);
disp(Vijk);

% Problem 3
elements = state2orbit(Rijk,Vijk,mu,0);
time2 = elements.t_p + 3600;
[true2,mean2,ecc2] = time2anomaly(time2,a,e,mu);
[Rijk2,Vijk2] = coe2state(a,e,i,raan,omega,true2,mu);
disp(Rijk2);
disp(Vijk2);