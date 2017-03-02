% Russell Bjella
% ASEN 5050 Final Project
% Three body integrator
% Main script

clear all
close all

% Start timer
tic

% Constants
G = 6.674e-11;          % Gravitational constant
M_m = 7.34767309e22;    % Mass of the moon [kg]
M_e = 5.97219e24;       % Mass of the Earth [kg]
M_s = 28833;            % Mass of Apollo lunar module [kg]
R_m = 1737.4*1000;           % Radius of the moon [km]
R_e = 6378.14*1000;          % Radius of the Earth [km]

% Initial state vector of the moon (at 9 Dec 2016 00:00:00 UT, from STK
pos_m0 = [366777.521650;52508.104973;4503.662572];  % [km]
vel_m0 = [-0.203893;0.980025;0.341115];     % [km/s]
state_m0 = [pos_m0;vel_m0]*1000;

% Compute initial state vector of the satellite
semimajor = R_e + 500;      % 500km orbit
ecc = 0.00001;
inc = 0;
raan = 0;
arg_peri = 0;
true = 0;
mu = G*M_e;     % Gravitational parameter of the Earth
[pos_s0,vel_s0] = coe2state(semimajor,ecc,inc,raan,arg_peri,true,mu);
state_s0 = [pos_s0;vel_s0]*1000;

% Compute trajectory of satellite over 6 month time span
t_span = [0 36000];
state0 = [state_s0;state_m0];
[t,y] = ode45(@(t,y)dydt(t,y),t_span,state0);

% Stop timer
toc

% Plot stuff
figure;hold on;grid on;
plot3(y(:,1),y(:,2),y(:,3),'.')
plot3(0,0,0,'LineWidth',4)
plot3(state_m0(1),state_m0(2),state_m0(3),'r','LineWidth',4)
title('500 km circular orbit');
xlabel('J2000 X [m]');ylabel('J2000 Y [m]');zlabel('J2000 Z [m]');

