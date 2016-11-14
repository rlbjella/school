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
sun_angle = diode2sun(a,b,c,d);
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
        fprintf('Theta = %f Phi = %f\n',azimuth(i),polar(k));
    end
end
toc
figure
hold on
grid on
surf(azimuth,polar,error)
xlabel('Azimuth [deg]');ylabel('Sun angle [deg]');zlabel('Error [arcmin]');
