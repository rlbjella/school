% Russell Bjella
% RADIANCE
% Photodiode sensitivity analysis

% Housekeeping
clear all
close all

% Some variables
 arcmin = 1/60;

% Test case (must return 1)
theta = 45;
phi = 1;
[a,b,c,d] = sun2diode(theta,phi);
tic
sun_angle = diode2sun(a,b,c,d);
toc
error = abs(sun_angle - phi)/arcmin;

% Sensitivity analyses
% Error versus off-sun angle (constant azimuth)
tic
azimuth = 0:5:360;
polar = 0:0.1:5;
error = zeros(length(polar),length(azimuth));
for i = 1:length(azimuth)
    for k = 1:length(polar)
        [a,b,c,d] = sun2diode(azimuth(i),polar(k));
        sun_angle = diode2sun(a,b,c,d);
        error(k,i) = abs(sun_angle - polar(k))/arcmin;
    end
end
toc
figure
hold on
grid on
surf(azimuth,polar,error)
xlabel('Azimuth [deg]');ylabel('Sun angle [deg]');zlabel('Error [arcmin]');

%% IMPROVED AND SIMPLIFIED
clear all;close all;clc;
da = 1;
dp = 0.3;
d = dp+da;
wa = 2.65;
theta_real = -2:0.0001:2;
theta_real = -20:0.1:20;
theta1 = 45 - theta_real;
theta2 = 45 + theta_real;
I1 = (wa - d*tand(theta1))/wa;
I1_raw = cosd(theta1);
I2 = (wa - d*tand(theta2))/wa;
I2_raw = cosd(theta2);
fprintf('I1 range: %f\t\tI1 range (no aperture): %f\n',range(I1),range(I1_raw));
fprintf('I2 range: %f\t\tI2 range (no aperture): %f\n',range(I2),range(I2_raw));

% Compute linearity of aperture and raw currents
p1 = polyfit(theta_real,I1,1);p1_raw = polyfit(theta_real,I1_raw,1);
p2 = polyfit(theta_real,I2,1);p2_raw = polyfit(theta_real,I2_raw,1);
I1_lin = p1(1)*theta_real+p1(2);
I1_raw_lin = p1_raw(1)*theta_real+p1_raw(2);
I2_lin = p2(1)*theta_real+p2(2);
I2_raw_lin = p2_raw(1)*theta_real+p2_raw(2);
% Mean and standard deviation of error from linear
fprintf('I1 aperture standard deviation from linear approximation: %f\n',std(abs(I1-I1_lin)));
fprintf('I1 no aperture standard deviation from linear approximation: %f\n',std(abs(I1_raw-I1_raw_lin)));

I3 = (wa - da*tand(45))/wa;
I4 = (wa - da*tand(45))/wa;
theta_calc = zeros(length(theta_real),1);
error = zeros(length(theta_real),1);
for i = 1:length(theta_real)
    theta_calc(i) = diode2sun(I3,I1(i),I4,I2(i));
    error(i) = abs(theta_calc(i) - abs(theta_real(i)));
end

figure(1);hold on;grid on;
plot(theta_real,error*60);
xlabel('Real sun angle [deg]');ylabel('Error [arcmin]');

figure(2);hold on;grid on;
plot(theta_real,I1);plot(theta_real,I2);
xlabel('Sun angle [deg]');ylabel('Relative current');
legend('I1','I2');
plot(theta_real,I1_raw,'b--');plot(theta_real,I2_raw,'r--');

figure(3);hold on;grid on;
plot(theta_real,theta_calc);
xlabel('Real sun angle [deg]');ylabel('Calculated sun angle [deg]');
