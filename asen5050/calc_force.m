function [F_es,F_em,F_ms] = calc_force(pos_s,pos_m)
% Russell Bjella
% ASEN 5050 Final Project
% Three body integrator
% Force calculator

% Constants
G = 6.674e-11;          % Gravitational constant
M_m = 7.34767309e22;    % Mass of the moon [kg]
M_e = 5.97219e24;       % Mass of the Earth [kg]
M_s = 28833;            % Mass of Apollo lunar module [kg]

% Compute distances
[r_es,r_em,r_ms] = calc_distance(pos_s,pos_m);

% Compute forces
F_es = -G*M_e*M_s / r_es^2 * pos_s;     % points from satellite to Earth
F_em = -G*M_e*M_m / r_em^2 * pos_m;     % points from moon to Earth
F_ms = G*M_m*M_s / r_ms^2 * (pos_m - pos_s);    % points from satellite to moon

end