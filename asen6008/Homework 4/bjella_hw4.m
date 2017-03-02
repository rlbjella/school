% Russell Bjella
% ASEN 6008 Homework 4
% 22 Feb 2017

clear all
close all

%% Problem 1
% Problem 1 givens
V_sc_sun = [-10.8559;-35.9372]; % S/c w.r.t. sun, km/s
V_ven_sun = [-15.1945;-31.7927]; % Venus w.r.t. sun
R_ven_sun = [-96948447.3751;46106976.1901];
mu_sun = 1.32712440018e11;
mu_venus = 3.257e5;
R_venus = 6052; % Venus radius, km
% Problem 1A
spec_energy_0 = norm(V_sc_sun)^2/2 - mu_sun/norm(R_ven_sun);
fprintf('PROBLEM 1A\n');
fprintf('Initial specific energy: %f km^2/s^2\n',spec_energy_0);
% Problem 1B
Vinf_mag = norm(V_sc_sun - V_ven_sun);
r_p = 0:1:200000;
cos_rho = 1./(1+Vinf_mag^2*r_p/mu_venus);
rho = acos(cos_rho);
psi = pi - 2*rho;
figure(1);hold on;grid on;
plot(r_p,psi*180/pi,'LineWidth',4);
title('1B: Turn angle vs radius of closest approach of Venus');
xlabel('Radius of closest approach [km]');
ylabel('Turn angle [deg]');
% Problem 1C
V_inf_in = V_sc_sun - V_ven_sun;
% Leading
spec_energy = zeros(length(r_p),1);
for i = 1:length(spec_energy)
    % Create rotation matrix for positive turn angle
    R = [cos(psi(i)) -sin(psi(i));sin(psi(i)) cos(psi(i))];
    V_inf_out = R*V_inf_in;
    V_dep = V_inf_out + V_ven_sun;
    spec_energy(i) = norm(V_dep)^2/2 - mu_sun/norm(R_ven_sun);
end
figure(2);hold on;grid on;
plot(r_p,spec_energy,'LineWidth',2);
plot(r_p,ones(length(r_p),1)*spec_energy_0,'LineWidth',2)
legend('Departure','Arrival');
title('1C: Specific energy after departure (leading)');
xlabel('Radius of closest approach [km]');
ylabel('Specific energy w.r.t. sun [km^2/s^2]');
% Trailing
spec_energy_t = zeros(length(r_p),1);
for i = 1:length(spec_energy)
    % Create rotation matrix for negative turn angle
    R = [cos(-psi(i)) -sin(-psi(i));sin(-psi(i)) cos(-psi(i))];
    V_inf_out = R*V_inf_in;
    V_dep = V_inf_out + V_ven_sun;
    spec_energy_t(i) = norm(V_dep)^2/2 - mu_sun/norm(R_ven_sun);
end
figure(3);hold on;grid on;
plot(r_p,spec_energy_t,'LineWidth',2);
plot(r_p,ones(length(r_p),1)*spec_energy_0,'LineWidth',2)
legend('Departure','Arrival');
title('1C: Specific energy after departure (trailing)');
xlabel('Radius of closest approach [km]');
ylabel('Specific energy w.r.t. sun [km^2/s^2]');

%% Problem 2
V_inf_in = [-5.19425;5.19424;-5.19425];
V_inf_out = [-8.58481;1.17067;-2.42304];
mu_e = 3.986004415e5;
% Calculate turn angle
psi = acos(dot(V_inf_in,V_inf_out)/(norm(V_inf_in)*norm(V_inf_out)));
fprintf('PROBLEM 2\nTurn angle: %f deg\n',psi*180/pi);
% Calculate radius of closest approach
r_p = mu_e/norm(V_inf_in)^2*(1/cos(pi/2-psi/2)-1);
fprintf('Radius of closest approach: %f km\n',r_p);
% Construct B-plane
S_hat = V_inf_in/norm(V_inf_in);
T_hat = cross(S_hat,[0;0;1])/norm(cross(S_hat,[0;0;1]));
R_hat = cross(S_hat,T_hat);
h_hat = cross(V_inf_in,V_inf_out)/norm(cross(V_inf_in,V_inf_out));
B_hat = cross(S_hat,h_hat);
V_inf = norm(V_inf_in);
% Calculate semi-minor axis
b = sqrt(mu_e^2/V_inf^4*((1+V_inf^2*r_p/mu_e)^2-1));
fprintf('Magnitude of B vector: %f km\n',b);
% Calculate direction of B vector and components
theta = acos(dot(T_hat,B_hat));
if (dot(B_hat,R_hat) < 0)
    theta = 2*pi - theta;
end
B_t = b*cos(theta);
B_r = b*sin(theta);
fprintf('Theta: %f deg\nB_T: %f km\nB_R: %f km\n',theta,B_t,B_r);

%% Problem 3
% Define dates
launch_jd = 2447807.5;
venus_jd = 2447932.5;
earth_1_jd = 2448235.5;
earth_2_jd = 2448966.0;
jupiter_jd = 2450164.0;
% Calculate planetary states
earth_state_0 = planetary_ephemerides('earth',launch_jd);
venus_state = planetary_ephemerides('venus',venus_jd);
earth_state_1 = planetary_ephemerides('earth',earth_1_jd);
% Solve Lambert's twice
[V0_a,Vf_a,dnu_a,psi_a] = lamberts(earth_state_0.R,venus_state.R,venus_jd-launch_jd,0,1);
[V0_b,Vf_b,dnu_b,psi_b] = lamberts(venus_state.R,earth_state_1.R,earth_1_jd-venus_jd,0,1);
% Calculate excess velocities of Venus flyby
V_inf_in = Vf_a - venus_state.V;
V_inf_out = V0_b - venus_state.V;
fprintf('PROBLEM 3\nV_inf_in: [%f %f %f] km/s\n',V_inf_in(1),V_inf_in(2),V_inf_in(3));
fprintf('V_inf_out: [%f %f %f] km/s\n',V_inf_out(1),V_inf_out(2),V_inf_out(3));
fprintf('|V_inf_in|: %f\t|V_inf_out|: %f\n',norm(V_inf_in),norm(V_inf_out));
% Calculate turn angle
psi = acos(dot(V_inf_in,V_inf_out)/(norm(V_inf_in)*norm(V_inf_out)));
% Calculate radius of closest approach
r_p = mu_e/norm(V_inf_in)^2*(1/cos(pi/2-psi/2)-1);
fprintf('Radius of closest approach: %f km\n',r_p);


