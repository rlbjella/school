%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050.m
% USAGE
%   N/A
% DESCRIPTION
%   Driver script for ASEN 5050 homework 7
% INPUTS
%   N/A
% OUTPUTS
%   N/A
%ENDHEADER

% Housekeeping
clear all
close all
format('long')
tic

% Physical constants
mu = 398600.4415; %gravitational parameter of Earth [km^3/s^2]

% Define initial conditions
X0 = [5492.000;3984.001;2.955;-3.931;5.498;3.665];
R = X0(1:3);
V = X0(4:6);

% Get orbital elements
elements = state2orbit(R,V,mu,1);
a = elements.a;
e = elements.e;
i = elements.i;
raan = elements.raan;
omega = elements.omega;
true = elements.true;

% Calculate initial time past periapsis
[~,~,~,t0,~] = anomalies(true,'true',a,e,mu,1);

% Calculate anomalies 100 seconds later and 1,000,000 seconds later
t1 = t0 + 100;
[true1,~,~,~,~] = anomalies(t1,'time',a,e,mu,1);
t2 = t0 + 1000000;
[true2,~,~,~,~] = anomalies(t2,'time',a,e,mu,1);
% Compute position and velocity vectors at t1 and t2
[R1,V1] = coe2state(a,e,i,raan,omega,true1,mu);
[R2,V2] = coe2state(a,e,i,raan,omega,true2,mu);

% Use ode45 to numerically propagate the orbit
time = [0:10:1000000];
tol = 1e-8;
options = odeset('RelTol',tol,'AbsTol',[tol,tol,tol,tol,tol,tol]);
[t,X] = ode45('two_body',time,X0,options);
t1_index = find(t == 100);
X1 = X(t1_index,1:6);
t2_index = find(t == 1000000);
X2 = X(t2_index,1:6);

% Tolerance study
tol_array = [1e-12;1e-10;1e-8;1e-6;1e-4];
deltaR = zeros(1,length(tol_array));
for i = 1:length(tol_array)
    tol = tol_array(i);
    options = odeset('RelTol',tol,'AbsTol',[tol,tol,tol,tol,tol,tol]);
    [t,X] = ode45('two_body',time,X0,options);
    t2_index = find(t == 1000000);
    R2_exp = X(t2_index,1:3);
    deltaR(i) = norm(R2_exp' - R2);
end

% Timing
toc
