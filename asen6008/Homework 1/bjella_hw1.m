% Russell Bjella
% ASEN 6008
% Homework 1
% 2/1/2017

clear all
close all

% Constants
mu_sun = 1.327e11;
mu_earth = 3.986e5;
mu_mars = 4.305e4;
AU = 1.4959787e8;
a_earth = AU;
a_mars = 1.52368*AU;
r_earth = 6378.1363;
r_mars = 3397.2;
r_p_earth = r_earth + 400;
r_p_mars = r_mars + 400;

%%% PART 1 %%%
% Part 1-A: departure and arrival velocities
% Transfer orbit SMA and velocities at apo/peri
a_trans = 0.5*(a_earth+a_mars);
v_depart = sqrt(2*mu_sun/a_earth - mu_sun/a_trans);
v_arrive = sqrt(2*mu_sun/a_mars - mu_sun/a_trans);

% Part 1-B: DV to depart Earth and arrive at Mars from 400km orbit
% Hyperbolic excess velocities at arrival and departure
v_earth = sqrt(mu_sun/a_earth);
v_mars = sqrt(mu_sun/a_mars);
v_inf_earth = v_depart - v_earth;
v_inf_mars = v_mars - v_arrive;
% SMA of escape trajectory and velocity at peri
a_depart = mu_earth/(v_inf_earth^2);
a_arrive = mu_mars/(v_inf_mars^2);
v_p_earth = sqrt(2*mu_earth/r_p_earth + mu_earth/a_depart);
v_p_mars = sqrt(2*mu_mars/r_p_mars + mu_mars/a_arrive);
% Calculate DV
v_circ_earth = sqrt(mu_earth/r_p_earth);
v_circ_mars = sqrt(mu_mars/r_p_mars);
DV_earth = v_p_earth - v_circ_earth;
DV_mars = v_p_mars - v_circ_mars;

% Part 1-C: transfer time of flight
TOF = pi*sqrt(a_trans^3/mu_sun);


%%% PART 2 %%%
% Position and velocity vectors
R_earth_0 = [-578441.002878924;-149596751.684464;0];
V_earth_0 = [29.7830732658560;-0.115161262358529;0];
R_mars_f = [-578441.618274359;227938449.869731;0];
V_mars_f = [-24.1281802482527;-0.0612303173808154;0];
R_sat = [0;-a_earth;0];
V_sat = [v_depart;0;0];
% Calculate initial position and velocity of Mars
n_mars = sqrt(mu_sun/a_mars^3);
theta_f = atan2(R_mars_f(2),R_mars_f(1));
theta_0 = theta_f - n_mars*TOF;
R_mars_0 = [a_mars*cos(theta_0);a_mars*sin(theta_0);0];
V_mars_0 = [v_mars*cos(theta_0+pi/2);v_mars*sin(theta_0+pi/2);0];

% Integrate satellite position, considering the sun, Earth, and Mars
% as well as only the sun. I accomplish this by providing the initial state
% vector for the satellite twice to fourbody_sun.m: the first state vector
% is propagated using all massive bodies, and the second state vector is
% propagated only considering the sun.
% Set options, initial conditions, and time span for ode45
options = odeset('AbsTol',1e-12,'RelTol',1e-12);
s0 = [R_sat;V_sat;R_sat;V_sat;R_earth_0;V_earth_0;R_mars_0;V_mars_0]; % Initial state
t_span = [0 TOF];
% Integrate
[t,y] = ode45(@(t,y)fourbody_sun(t,y),t_span,s0);

% Plots
% Plot comparison of trajectories
figure;hold on;grid on;
xlabel('X [km]');ylabel('Y [km]');
title('Ideal vs perturbed Hohmann transfer from Earth to Mars');
ang = 0:0.01:2*pi;
plot(a_earth*cos(ang),a_earth*sin(ang),'b')
plot(a_mars*cos(ang),a_mars*sin(ang),'r')
plot(R_earth_0(1),R_earth_0(2),'b*')
plot(R_mars_f(1),R_mars_f(2),'r*')
plot(y(:,7),y(:,8),'k')
plot(y(:,1),y(:,2),'k--')
axis square
legend('Earth orbit','Mars orbit','Earth initial position','Mars final position','Ideal transfer','Perturbed transfer')
% Plot differences in position
figure;hold on;grid on;
xlabel('Days since Earth departure');ylabel('Error in position [km]')
title('Error in position for ideal vs perturbed transfer')
plot(t,y(:,1)-y(:,7));plot(t,y(:,2)-y(:,8))
legend('X (perturbed) - X (ideal)','Y (perturbed) - Y (ideal)')
% Plot differences in velocity
figure;hold on;grid on;
xlabel('Days since Earth departure');ylabel('Error in velocity [km]')
title('Error in velocity for ideal vs perturbed transfer')
plot(t,y(:,4)-y(:,10));plot(t,y(:,5)-y(:,11))
legend('Vx (perturbed) - Vx (ideal)','Vy (perturbed) - Vy (ideal)')











