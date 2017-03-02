function f = fourbody_sun(t,y)
% Russell Bjella
% Function for ode45 for two-body motion assuming the central body is
% at the origin.

% Constants
mu_sun = 1.327e11;
mu_earth = 3.986e5;
mu_mars = 4.305e4;
   
% Extract position and velocity
pos_sat = y(1:3); vel_sat = y(4:6);     % All bodies
pos_sat_sun = y(7:9); vel_sat_sun = y(10:12); % Sun only
pos_earth = y(13:15); vel_earth = y(16:18);
pos_mars = y(19:21); vel_mars = y(22:24);
% Compute acceleration vector of satellite
pos_rel_e = pos_sat - pos_earth;
pos_rel_m = pos_sat - pos_mars;
accel_sat_s = -mu_sun*pos_sat/norm(pos_sat)^3;  % Acceleration due to sun
accel_sat_e = -mu_earth*pos_rel_e/norm(pos_rel_e)^3;  % Acceleration due to Earth
accel_sat_m = -mu_mars*pos_rel_m/norm(pos_rel_m)^3;  % Acceleration due to Mars
accel_sat = accel_sat_s + accel_sat_e + accel_sat_m;
% Compute acceleration vector of Earth and Mars
accel_earth = -mu_sun*pos_earth/norm(pos_earth)^3;
accel_mars = -mu_sun*pos_mars/norm(pos_mars)^3;
% Compute acceleration vector of satellite (sun only)
accel_sat_sun = -mu_sun*pos_sat_sun/norm(pos_sat_sun)^3;

% Construct RHS vector
f(1,1) = vel_sat(1);
f(2,1) = vel_sat(2);
f(3,1) = vel_sat(3);
f(4,1) = accel_sat(1);
f(5,1) = accel_sat(2);
f(6,1) = accel_sat(3);
f(7,1) = vel_sat_sun(1);
f(8,1) = vel_sat_sun(2);
f(9,1) = vel_sat_sun(3);
f(10,1) = accel_sat_sun(1);
f(11,1) = accel_sat_sun(2);
f(12,1) = accel_sat_sun(3);
f(13,1) = vel_earth(1);
f(14,1) = vel_earth(2);
f(15,1) = vel_earth(3);
f(16,1) = accel_earth(1);
f(17,1) = accel_earth(2);
f(18,1) = accel_earth(3);
f(19,1) = vel_mars(1);
f(20,1) = vel_mars(2);
f(21,1) = vel_mars(3);
f(22,1) = accel_mars(1);
f(23,1) = accel_mars(2);
f(24,1) = accel_mars(3);

end