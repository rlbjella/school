function f = dydt(t,y)
%BEGINHEADER
% SOURCE
%   $.m
% USAGE
%   y = x(a,b)
% DESCRIPTION
%   
% INPUTS
%   y = initial state vector (12 elements, position and velocity of
%   satellite followed by position and velocity of moon)
% OUTPUTS
%   y = output [unit]
%ENDHEADER

% Constants
M_m = 7.34767309e22;    % Mass of the moon [kg]
M_e = 5.97219e24;       % Mass of the Earth [kg]
M_s = 28833;            % Mass of Apollo lunar module [kg]

% Get position and velocity vectors from full state vector
pos_s = y(1:3); vel_s = y(4:6);     % Position and velocity of satellite
pos_m = y(7:9); vel_m = y(10:12);   % Position and velocity of moon

% Compute forces
[F_es,F_em,F_ms] = calc_force(pos_s,pos_m);
% Compute accelerations
a_s = (F_es + F_ms)/M_s;
a_m = F_em/M_m;

% Construct y'
f(1,1) = vel_s(1);
f(2,1) = vel_s(2);
f(3,1) = vel_s(3);
f(4,1) = a_s(1);
f(5,1) = a_s(2);
f(6,1) = a_s(3);
f(7,1) = vel_m(1);
f(8,1) = vel_m(2);
f(9,1) = vel_m(3);
f(10,1) = a_m(1);
f(11,1) = a_m(2);
f(12,1) = a_m(3);

end

