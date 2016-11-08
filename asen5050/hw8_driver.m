% ASEN 5050 HW 8 driver
% Russell Bjella

% HK
clear all
close all

%% Problem 1
R_earth = 6378.1363;
J2 = 0.0010826269;
mu = 398600.4415;
h = 800;
a = R_earth + h;
e = 0;
central_period = 365.2421897;
sunsync_inclination = sunsync(a,e,R_earth,J2,mu,central_period,'Earth')

%% Problem 2
% Constants for each planet
R_merc = 2439.0;
R_venus = 6052.0;
R_moon = 1738;
R_mars = 3397.2;
R_jup = 71492;
R_sat = 60268;
R_ur = 25559;
R_nep = 24764;
J2_merc = 0.00006;
J2_venus = 0.000027;
J2_moon = 0.0002027;
J2_mars = 0.001964;
J2_jup = 0.01475;
J2_sat = 0.01645;
J2_ur = 0.012;
J2_nep = 0.004;
period_merc = 87.9666;
period_venus = 224.6906;
period_moon = 27.321582;
period_mars = 686.9150;
period_jup = 4330.5958;
period_sat = 10746.94031;
period_ur = 30588.74004;
period_nep = 59799.90044;
mu_merc = 2.2032e4;
mu_venus = 3.257e5;
mu_moon = 4902.799;
mu_mars = 4.305e4;
mu_jup = 1.268e8;
mu_sat = 3.794e7;
mu_ur = 5.794e6;
mu_nep = 6.809e6;
% Compute sunsync inclination for each
h = 800;
inc_merc = sunsync(R_merc+h,0,R_merc,J2_merc,mu_merc,period_merc,'Mercury')
inc_venus = sunsync(R_venus+h,0,R_venus,J2_venus,mu_venus,period_venus,'Venus')
inc_moon = sunsync(R_moon+h,0,R_moon,J2_moon,mu_moon,period_moon,'Moon')
inc_mars = sunsync(R_mars+h,0,R_mars,J2_mars,mu_mars,period_mars,'Mars')
inc_jup = sunsync(R_jup+h,0,R_jup,J2_jup,mu_jup,period_jup,'Jupiter')
inc_sat = sunsync(R_sat+h,0,R_sat,J2_sat,mu_sat,period_sat,'Saturn')
inc_ur = sunsync(R_ur+h,0,R_ur,J2_ur,mu_ur,period_ur,'Uranus')
inc_nep = sunsync(R_nep+h,0,R_nep,J2_nep,mu_nep,period_nep,'Neptune')