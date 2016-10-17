% Russell Bjella
% ASEN 4013
% Homework 7
% Problem 4.4
% 10/17/2016

% Housekeeping
clear all
close all
clc

% Precalculated constants
p3 = 1e6;   % Pa
V3 = 150;   % m/s
T3 = 773.15;    % K
mf_map = 0.066;
eta_b = 0.96;
HV = 44e6;    % MJ/kg
cp = 1.37e3;  % J/kg-K
gamma = 1.27;
W = 28.96;
a3 = 513.84;    % m/s
M3 = 0.2919;
Tt3 = 782.04;   % K

% Vary secondary air ratio
mas_ma = 0:0.05:1;
mf_ma = 0.066*(1 - mas_ma);

% Solve for Tt4
Tt4 = (mf_ma.*eta_b*HV+cp*Tt3) ./ ((1+mf_ma)*cp);
% Compute M4
M4 = M3 ./ sqrt(Tt4./Tt3);