function f = twobody_sun(t,y)
% Russell Bjella
% Function for ode45 for two-body motion assuming the central body is
% at the origin.

% Constants
mu_sun = 1.327e11;
   
% Extract position and velocity
pos = y(1:3); vel = y(4:6);
% Compute acceleration vector
accel = -mu_sun*pos/norm(pos)^3;

% Construct RHS vector
f(1,1) = vel(1);
f(2,1) = vel(2);
f(3,1) = vel(3);
f(4,1) = accel(1);
f(5,1) = accel(2);
f(6,1) = accel(3);

end