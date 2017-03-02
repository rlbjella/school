% Russell Bjella
% ASEN 6008
% Homework 2

% Housekeeping
clear all
close all

%% Problem 1
AU = 149597870.691;     % Kilometers in an AU
mu_sun = 1.32712440018e11;  % km^3/s^2
launch_jd = utc2jd(2018,5,1);
earth_state = planetary_ephemerides('earth',launch_jd);
TOF = 100:400;  % Vary time of flight
delta_nu = zeros(length(TOF),1);
C3 = zeros(length(TOF),1);      % Launch C3
Vinf = zeros(length(TOF),1);    % Arrival excess velocity
% Compute trajectory for each time of flight
for i = 1:length(TOF)
    mars_state = planetary_ephemerides('mars',launch_jd+TOF(i));
    [V0,Vf,dnu(i),psi] = lamberts(earth_state.R,mars_state.R,TOF(i));
    Vinf_earth = earth_state.V - V0;
    C3(i) = norm(Vinf_earth)^2;
    Vinf_mars = mars_state.V - Vf;
    Vinf(i) = norm(Vinf_mars);
end
% Parse out type I and type II transfers
type1 = find(dnu<pi);
type2 = find(dnu>pi);
TOF_1 = TOF(type1);
TOF_2 = TOF(type2);
% Create plots for type I
figure;hold on;grid on;
plot(TOF(type1),C3(type1))
title('Type I');xlabel('Days since May 1, 2018');ylabel('C3');
figure;hold on;grid on;
plot(TOF(type1),Vinf(type1))
title('Type I');xlabel('Days since May 1, 2018');ylabel('Vinf @ Mars [km/s]');
% Create plots for type II
figure;hold on;grid on;
plot(TOF(type2),C3(type2))
title('Type II');xlabel('Days since May 1, 2018');ylabel('C3');
figure;hold on;grid on;
plot(TOF(type2),Vinf(type2))
title('Type II');xlabel('Days since May 1, 2018');ylabel('Vinf @ Mars [km/s]');
% Print out desired quantities for the assignment
[a1,Ia] = min(C3(type1));
a2 = TOF_1(Ia);
[b1,Ib] = min(Vinf(type1));
b2 = TOF_1(Ib);
[c1,Ic] = min(C3(type2));
c2 = TOF_2(Ic);
[d1,Id] = min(Vinf(type2));
d2 = TOF_2(Id);




%% Problem 2
AU = 149597870.691;     % Kilometers in an AU
mu_sun = 1.32712440018e11;  % km^3/s^2
a_transfer = AU*(2.17+2.57)/2;  % Transfer orbit SMA, km
e_transfer = (2.57-2.17)/(2.57+2.17);
T_ceres = 1682*86169.1;     % Ceres period, seconds
e_ceres = 0.0758;   % Ceres eccentricity
a_ceres = (mu_sun*(T_ceres/(2*pi))^2)^(1/3);
r_final = a_ceres*(1-e_ceres);
true = 0:0.01:360;
r = 0;
i = 1;
while (r < r_final)
    [~,~,~,time,r] = anomalies(true(i),'true',a_transfer,e_transfer,mu_sun,0);
    i = i+1;
end
time/86164.1    % Output time of flight in days





