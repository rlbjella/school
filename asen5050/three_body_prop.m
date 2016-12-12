%BEGINHEADER
% SOURCE
%   $.m
% USAGE
%   y = x(a,b)
% DESCRIPTION
%   
% INPUTS
%   a = input [unit]
% OUTPUTS
%   y = output [unit]
%ENDHEADER

% Start timer
tic

% Constants
G = 6.674e-11/1000^3;          % Gravitational constant
M_m = 7.34767309e22;    % Mass of the moon [kg]
M_e = 5.97219e24;       % Mass of the Earth [kg]
M_s = 28833;            % Mass of Apollo lunar module [kg]
R_m = 1737.4;           % Radius of the moon [km]
R_e = 6378.14;          % Radius of the Earth [km]

% Initial state vector of the moon (at 9 Dec 2016 00:00:00 UT, from STK
pos_m0 = [366777.521650;52508.104973;4503.662572];  % [km]
vel_m0 = [-0.203893;0.980025;0.341115];     % [km/s]
state_m0 = [pos_m0;vel_m0];

% Compute initial state vector of the satellite
semimajor = R_e + 500;      % 500km orbit
ecc = 0.00001;
inc = 0;
raan = 0;
arg_peri = 0;
true = 0;
mu = G*M_e;     % Gravitational parameter of the Earth
[pos_s0,vel_s0] = coe2state(semimajor,ecc,inc,raan,arg_peri,true,mu);
state_s0 = [pos_s0;vel_s0];

% Compute trajectory of satellite over 6 month time span
t_span = [0 3600];
state0 = [state_s0;state_m0];
[t,y] = ode45(@(t,y)dydt(t,y),t_span,state0);

% Stop timer
toc

% Plot stuff
figure;hold on;grid on;
plot(y(:,1),y(:,2))
