% Russell Bjella
% ASEN 6008 - Lab 4
% Porkchop Plots
% 2/22/2017

close all
clear all

%% 2018 Earth to Mars opportunity
tic

jd_depart = 2458200:0.1:2458320;  % Mar 22 2018 to Jul 20 2018
jd_arrive = 2458350:0.1:2458600;  % Aug 19 2018 to Apr 26 2019

% Create result matrices
c3 = zeros(length(jd_arrive),length(jd_depart));
Vinf = zeros(length(jd_arrive),length(jd_depart));
dnu = zeros(length(jd_arrive),length(jd_depart));
psi = zeros(length(jd_arrive),length(jd_depart));
TOF = zeros(length(jd_arrive),length(jd_depart));

% Loop through departure and arrival dates
for i = 1:length(jd_depart)
    [earth_state] = planetary_ephemerides('earth',jd_depart(i));
    R_e = earth_state.R;
    V_e = earth_state.V;
    for j = 1:length(jd_arrive)
        [mars_state] = planetary_ephemerides('mars',jd_arrive(j));
        R_m = mars_state.R;
        V_m = mars_state.V;
        TOF(j,i) = jd_arrive(j)-jd_depart(i);
        [V0,Vf,dnu(j,i),psi(j,i)] = lamberts(R_e,R_m,TOF(j,i),0,1);
        Vinf_e = norm(V0-V_e);
        c3(j,i) = Vinf_e^2;
        Vinf(j,i) = norm(Vf-V_m);
    end
end

% Define contour levels
c3_contours = [5;6;7;8;10;15;20;25;30;50];
Vinf_contours = [1;2;3;3.5;4;4.5;5];
% Plot
figure(1);hold on;grid on;
[cs1,h1]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),c3,c3_contours,'b');
clabel(cs1,h1);
[cs2,h2]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),Vinf,Vinf_contours,'r');
clabel(cs2,h2);
[cs3,h3]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),TOF,'k');
clabel(cs3,h3);
legend('C3 @ Earth [km^2/s^2]','Vinf @ Mars [km/s]','Time of flight [days]');
title('Porkchop Plot for 2018 Earth-Mars Opportunity');
xlabel('Departure - days since 22 Mar 2018');
ylabel('Arrival - days since 20 Jul 2018');

toc



%% 2016 Earth to Mars opportunity
tic
jd_depart = 2457389:0.1:2457509;  % Mar 22 2018 to Jul 20 2018
jd_arrive = 2457570:0.1:2457790;  % Aug 19 2018 to Apr 26 2019

% Create result matrices
c3 = zeros(length(jd_arrive),length(jd_depart));
Vinf = zeros(length(jd_arrive),length(jd_depart));
dnu = zeros(length(jd_arrive),length(jd_depart));
psi = zeros(length(jd_arrive),length(jd_depart));
TOF = zeros(length(jd_arrive),length(jd_depart));

% Loop through departure and arrival dates
for i = 1:length(jd_depart)
    [earth_state] = planetary_ephemerides('earth',jd_depart(i));
    R_e = earth_state.R;
    V_e = earth_state.V;
    for j = 1:length(jd_arrive)
        [mars_state] = planetary_ephemerides('mars',jd_arrive(j));
        R_m = mars_state.R;
        V_m = mars_state.V;
        TOF(j,i) = jd_arrive(j)-jd_depart(i);
        [V0,Vf,dnu(j,i),psi(j,i)] = lamberts(R_e,R_m,TOF(j,i),0,1);
        Vinf_e = norm(V0-V_e);
        c3(j,i) = Vinf_e^2;
        Vinf(j,i) = norm(Vf-V_m);
    end
end

% Define contour levels
c3_contours = [5;6;7;8;10;15;20;25;30;50];
Vinf_contours = [1;2;3;3.5;4;4.5;5];
% Plot
figure(2);hold on;grid on;
[cs1,h1]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),c3,c3_contours,'b');
clabel(cs1,h1);
[cs2,h2]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),Vinf,Vinf_contours,'r');
clabel(cs2,h2);
[cs3,h3]=contour(jd_depart-jd_depart(1),jd_arrive-jd_arrive(1),TOF,'k');
clabel(cs3,h3);
legend('C3 @ Earth [km^2/s^2]','Vinf @ Mars [km/s]','Time of flight [days]');
title('Porkchop Plot for 2016 Earth-Mars Opportunity');
xlabel('Departure - days since 1 Jan 2016');
ylabel('Arrival - days since 30 Jun 2016');

toc
