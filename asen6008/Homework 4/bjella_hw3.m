% Russell Bjella
% ASEN 6008 Homework 3 driver
% 2/15/2017

clear all
close all
MU = 1.32712440018e11;

%% Problem 1
depart_date = 2454085.5;
arrive_date = depart_date + 830;
mars_state = planetary_ephemerides('mars',depart_date);
R_mars = mars_state.R
jupiter_state = planetary_ephemerides('jupiter',arrive_date);
R_jup = jupiter_state.R

%% Problem 2
% Zero rev
TOF_array_0 = 200:10:30000;
psi_array_0 = zeros(length(TOF_array_0),1);
for i = 1:length(TOF_array_0)
    depart_date = arrive_date + TOF_array_0;
    [~,~,~,psi_array_0(i)] = lamberts(R_mars,R_jup,TOF_array_0(i),0,1);
end
figure;hold on;grid on;
plot(psi_array_0,TOF_array_0,'LineWidth',4)
% Multi rev
TOF_array_m = 2600:10:30000;
psi_array_m_a = zeros(length(TOF_array_m),1);
psi_array_m_b = zeros(length(TOF_array_m),1);
for i = 1:length(TOF_array_m)
    depart_date = arrive_date + TOF_array_m(i);
    [~,~,~,psi_array_m_a(i)] = lamberts(R_mars,R_jup,TOF_array_m(i),1,3);
    [~,~,~,psi_array_m_b(i)] = lamberts(R_mars,R_jup,TOF_array_m(i),1,4);
    %[~,~,psi_array_m(i),~] = Lamberts2(R_mars,R_jup,TOF_array_m(i)*86400,1,MU);
end
plot(psi_array_m_a,TOF_array_m)
plot(psi_array_m_b,TOF_array_m,'LineWidth',4)
title('Time of Flight vs PSI for Mars-Jupiter trajectories')
xlabel('Psi [rad^2]');ylabel('Time of flight [days]');
legend('Type 1/2','Type 3','Type 4')
