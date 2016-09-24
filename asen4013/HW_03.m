% ASEN 4013 HW03 (3.1, 3.2, 3.3, 3.4 Ideal Cycle Analysis)
clear all
close all
clc

%% 3.1 Ideal Cycle Turbojet
fprintf('3.1 Turbojet) \n')

% Given (assume all efficiencies are 100%)
alt = 11e3;                     %m, cruise altitude
M0 = 0.9;                       %cruise mach
mdot0 = 29.17;                  %kg/s, mass flow of air at inlet
T04 = 1330;                     %K, stag pressure at turbine inlet
HV = 44e6;                      %J/kg, heating value of fuel

pid = 1;                        %pt,2/pt,0 = 1; MIL-E-5008B
pic = 18;                       %pt,3/pt,2
pib = 1;                        %pt,4/pt,3
pin = 1;                        %pt,9/pt,7

% Constants, Tables
g0 = 9.8067;                    %m/s^2, acceleration of gravity on Earth
R = 286.9;                      %J/kg-K, gas constant for air
gam = 1.4;                      %specific heat ratio air
Cp = gam/(gam-1)*R;             %J/kg-K 
p0static = 22.632E3;            %Pa, static press from std atmo at 11km
T0static = 216.65;              %K, static temp from std atom at 11km
a0 = 295.07;                    %m/s, speed of sound std atmo at 11km
v0 = a0*M0;                     %m/s, flight speed

% i) Free Stream - Station 0
taor = 1+(gam-1)/2*M0^2;                        %Tt,0/T0static
pir = taor^((gam)/(gam-1));                     %Pt,0/P0static
p0 = p0static*pir;                              %Pa, stag press
T0 = T0static*taor;                             %K, stag press
fprintf('Station 0 - Ambient: \n')
fprintf('  Pt,0 = %6.2f kPa \n', p0/1000)
fprintf('  Tt,0 = %6.2f K \n\n', T0)

% ii) Inlet - Station 2
p02 = p0*pid;                                   %Pa, stag press
T02 = T0;                                       %K, stag temp
fprintf('Station 1&2 - Inlet/Compressor Face: \n')
fprintf('  Pt,1 = Pt,2 = %6.2f kPa \n', p02/1000)
fprintf('  Tt,1 = Tt,2 = %6.2f K \n\n', T02)

% iii) Compressor - Station 3; assume isentropic compression
%      Tt,3/Tt,2 = (pt,3/pt,2)^((gam-1)/gam); pt,3/pt,2 = pic = 18
p03 = pic*p02;                                  %Pa, stag press
taoc = pic^((gam-1)/gam);                       %Tt,3/Tt,2
T03 = T02*taoc;                                 %K, stag temp
fprintf('Station 3 - Compressor Exit: \n')
fprintf('  Pt,3 = %6.2f kPa \n', p03/1000)
fprintf('  Tt,3 = %6.2f K \n\n', T03)

% iv) Combustor - Stations 3-4
p04 = pib*p03;                                  %Pa, stag press
T04 = T04;                                      %K, stag temp; given

taolam = T04/T0static;                          %max temp ratio, Tt,4/T0
f = Cp*T0static/HV*(taolam-taor*taoc);          %f/a

fprintf('Station 4 - Turbine Entry: \n')
fprintf('  Pt,4 = %7.2f kPa \n', p04/1000)
fprintf('  Tt,4 = %7.2f K \n\n', T04)

% v) Turbine - Station 5
taot = 1-taor/taolam*(taoc-1);                  %Tt,5/Tt,4
pit = taot^(gam/(gam-1));                       %Pt,5/Pt,4
p05 = p04*pit;                                  %Pa, stag press
T05 = T04*taot;                                 %K, stag temp
fprintf('Station 5 - Turbine Exit: \n')
fprintf('  Pt,5 = %7.2f kPa \n', p05/1000)
fprintf('  Tt,5 = %7.2f K \n\n', T05)

% vi) Nozzle Entry - Stations 5-7
p07 = p05;                                      %Pa, stag press
T07 = T05;                                      %K, stag temp
fprintf('Station 7 - Nozzle Entry: \n')
fprintf('  Pt,6 = Pt,7 = %7.2f kPa \n', p07/1000)
fprintf('  Tt,6 = Tt,7 = %7.2f K \n\n', T07)

% vii) Nozzle Exit - Station 9; assume perfect expansion
p09 = pin*p07;                                  %Pa, stag press
T09 = T07;                                      %K, stag temp (taon = 1)                              
p9 = p0static;                                  %Pa, static press

X = 2/(gam-1);
Y = (p09/p9)^((gam-1)/gam)-1;
M9 = sqrt(X*Y);                                 %exit Mach
Z = 1+(gam-1)/2*M9^2;
T9 = T09/Z;                                     %K, static temp
fprintf('Station 9 - Nozzle Exit: \n')
fprintf('  Pt,9 = %7.2f kPa \n', p09/1000)
fprintf('  Tt,9 = %7.2f K \n', T09)
fprintf('  P9   = %7.2f kPa \n', p9/1000)
fprintf('  T9   = %7.2f K \n', T9)
fprintf('  M9   = %7.2f \n\n',M9)

% vii) Turbojet Performance
X = 2/(gam-1);                                  
Y = (taolam/(taor*taoc));                    
Z = (taor*taoc*taot-1);                      
u9_a0 = (X*Y*Z)^(1/2);                          %exit velocity/free stream speed of sound

ST = a0*(u9_a0-M0);                             %m/s, specific thrust
SFC = f/ST;                                     %kg/s-N, specific fuel consumption
Isp = 1/(SFC*g0);                               %s, specific impulse

Fr = mdot0*v0;                                  %N, ram drag
Fnet = mdot0*ST;                                %N, net thrust
Fg = Fr+Fnet;                                   %N, gross thrust

nth = 1-1/(taor*taoc);                          %thermal efficiency
np = 2/(1+(u9_a0/M0));                          %propulsive efficiency
no = nth*np;                                    %overall efficiency

fprintf('Turbojet Performance: \n')
fprintf('  Specific Thrust    = %7.2f m/s \n', ST)
fprintf('  SFC                = %7.2f mg/s-N \n', SFC*10^6)
fprintf('  Isp                = %7.2f s \n',Isp)
fprintf('  Fg                 = %7.2f kN \n', Fg/1000)
fprintf('  Fnet               = %7.2f kN \n', Fnet/1000)
fprintf('  Overall Efficiency = %7.0f %% \n\n\n', no*100)

%% 3.2 Ideal Cycle Turbofan
fprintf('3.2 Turbofan) \n')

% Given (assume all efficiencies are 100%)
alt = 11e3;                     %m, cruise altitude
M0 = 0.9;                       %cruise mach
mdot0 = 50.00;                  %kg/s, mass flow of air at inlet
T04 = 1330;                     %K, stag pressure at turbine inlet
HV = 44e6;                      %J/kg, heating value of fuel
BPR = 1;                        %bypass ratio

pid = 1;                        %pt,2/pt,0 = 1; MIL-E-5008B
pic = 18;                       %pt,3/pt,2
piF = 2.2;                      %pt,3F/pt,2
pib = 1;                        %pt,4/pt,3
pin = 1;                        %pt,9/pt,7
pinF = 1;                       %pt,9F/pt,7F

% Constants, Tables
g0 = 9.8067;                    %m/s^2, acceleration of gravity on Earth
R = 286.9;                      %J/kg-K, gas constant for air
gam = 1.4;                      %specific heat ratio air
Cp = gam/(gam-1)*R;             %J/kg-K 
p0static = 22.632E3;            %Pa, static press from std atmo at 11km
T0static = 216.65;              %K, static temp from std atom at 11km
a0 = 295.07;                    %m/s, speed of sound std atmo at 11km
v0 = a0*M0;                     %m/s, flight speed

% i) Free Stream - Station 0
taor = 1+(gam-1)/2*M0^2;                        %Tt,0/T0static
pir = taor^((gam)/(gam-1));                     %Pt,0/P0static
p0 = p0static*pir;                              %Pa, stag press
T0 = T0static*taor;                             %K, stag press
fprintf('Station 0 - Ambient: \n')
fprintf('  Pt,0 = %6.2f kPa \n', p0/1000)
fprintf('  Tt,0 = %6.2f K \n\n', T0)

% ii) Inlet - Station 2
p02 = p0*pid;                                   %Pa, stag press
T02 = T0;                                       %K, stag temp
fprintf('Station 1&2 - Inlet/Compressor Face: \n')
fprintf('  Pt,1 = Pt,2 = %6.2f kPa \n', p02/1000)
fprintf('  Tt,1 = Tt,2 = %6.2f K \n\n', T02)

% iii_a) Compressor - Station 3; assume isentropic compression
%      Tt,3/Tt,2 = (pt,3/pt,2)^((gam-1)/gam); pt,3/pt,2 = pic = 18
p03 = pic*p02;                                  %Pa, stag press
taoc = pic^((gam-1)/gam);                       %Tt,3/Tt,2
T03 = T02*taoc;                                 %K, stag temp
fprintf('Station 3 - Compressor Exit: \n')
fprintf('  Pt,3 = %6.2f kPa \n', p03/1000)
fprintf('  Tt,3 = %6.2f K \n\n', T03)

% iii_b) Fan - Station 3F; assume isentropic compression
p03F = piF*p02;                                 %Pa, stag press
taoF = piF^((gam-1)/gam);                       %Tt,3F/Tt,2
T03F = T02*taoF;                                %K, stag temp
fprintf('Station 3F - Fan Exit: \n')
fprintf('  Pt,3F = %6.2f kPa \n', p03F/1000)
fprintf('  Tt,3F = %6.2f K \n\n', T03F)

% iv) Combustor - Stations 3-4
p04 = pib*p03;                                  %Pa, stag press
T04 = T04;                                      %K, stag temp; given

taolam = T04/T0static;                          %max temp ratio, Tt,4/T0
f = Cp*T0static/HV*(taolam-taor*taoc);          %f/a

fprintf('Station 4 - Turbine Entry: \n')
fprintf('  Pt,4 = %7.2f kPa \n', p04/1000)
fprintf('  Tt,4 = %7.2f K \n\n', T04)

% v) Turbine - Station 5
X = taor/taolam;
Y = taoc-1;
Z = BPR*(taoF-1);
taot = 1-X*(Y+Z);                               %Tt,5/Tt,4
pit = taot^(gam/(gam-1));                       %Pt,5/Pt,4
p05 = p04*pit;                                  %Pa, stag press
T05 = T04*taot;                                 %K, stag temp
fprintf('Station 5 - Turbine Exit: \n')
fprintf('  Pt,5 = %7.2f kPa \n', p05/1000)
fprintf('  Tt,5 = %7.2f K \n\n', T05)

% vi_a) Core Nozzle Entry - Stations 5-7
p07 = p05;                                      %Pa, stag press
T07 = T05;                                      %K, stag temp
fprintf('Station 7 - Core Nozzle Entry: \n')
fprintf('  Pt,6 = Pt,7 = %6.2f kPa \n', p07/1000)
fprintf('  Tt,6 = Tt,7 = %6.2f K \n\n', T07)

% vi_b) Fan Nozzle Entry - Stations 3F-7
p07F = p03F;                                    %Pa, stag press
T07F = T03F;                                    %K, stag temp
fprintf('Station 7F - Fan Nozzle Entry: \n')
fprintf('  Pt,7F = %6.2f kPa \n', p07F/1000)
fprintf('  Tt,7F = %6.2f K \n\n', T07F)

% vii_a) Core Nozzle Exit - Station 9; assume perfect expansion
p09 = pin*p07;                                  %Pa, stag press
T09 = T07;                                      %K, stag temp (taon = 1)                              
p9 = p0static;                                  %Pa, static press

X = 2/(gam-1);
Y = (p09/p9)^((gam-1)/gam)-1;
M9 = sqrt(X*Y);                                 %exit Mach
Z = 1+(gam-1)/2*M9^2;
T9 = T09/Z;                                     %K, static temp
fprintf('Station 9 - Nozzle Exit: \n')
fprintf('  Pt,9 = %7.2f kPa \n', p09/1000)
fprintf('  Tt,9 = %7.2f K \n', T09)
fprintf('  P9   = %7.2f kPa \n', p9/1000)
fprintf('  T9   = %7.2f K \n', T9)
fprintf('  M9   = %7.2f \n\n',M9)

% vii_b) Fan Nozzle Exit - Station 9; assume perfect expansion
p09F = pinF*p07F;                               %Pa, stag press
T09F = T07F;                                    %K, stag temp (taonF = 1)                              
p9F = p0static;                                 %Pa, static press

X = 2/(gam-1);
Y = (p09F/p9F)^((gam-1)/gam)-1;
M9F = sqrt(X*Y);                                %exit Mach
Z = 1+(gam-1)/2*M9F^2;
T9F = T09F/Z;                                   %K, static temp
fprintf('Station 9F - Fan Nozzle Exit: \n')
fprintf('  Pt,9F = %7.2f kPa \n', p09F/1000)
fprintf('  Tt,9F = %7.2f K \n', T09F)
fprintf('  P9F   = %7.2f kPa \n', p9F/1000)
fprintf('  T9F   = %7.2f K \n', T9F)
fprintf('  M9F   = %7.2f \n\n',M9F)

% vii) Turbofan Performance
X = 2/(gam-1);                                 
Y = (taolam/(taor*taoc));                  
Z = (taor*taoc*taot-1);                     
u9_a0 = (X*Y*Z)^(1/2);                          %exit velocity/free stream speed of sound
u9_a0F = (X*(taor*taoF-1))^(1/2);               %exit velocity(fan)/free stream speed of sound

X = (1+BPR);                                  
Y = u9_a0-M0;                                   
Z = BPR*(u9_a0F-M0);                          
ST = a0/X*(Y+Z);                                %m/s, specific thrust
SFC = f/(X*ST);                                 %kg/s-N, specific fuel consumption
Isp = 1/(SFC*g0);                               %s, specific impulse

Fr = mdot0*v0;                                  %N, ram drag
Fnet = mdot0*ST;                                %N, net thrust
Fg = Fr+Fnet;                                   %N, gross thrust

nth = 1-1/(taor*taoc);                          %thermal efficiency
W = u9_a0-M0;                                   
X = BPR*(u9_a0F-M0);                           
Y = u9_a0^2-M0^2;                               
Z = BPR*(u9_a0F^2-M0^2);                       
np = (2*M0*(W+X))/(Y+Z);                        %propulsive efficiency
no = nth*np;                                    %overall efficiency

fprintf('Turbofan Performance: \n')
fprintf('  Specific Thrust    = %7.2f m/s \n', ST)
fprintf('  SFC                = %7.2f mg/s-N \n', SFC*10^6)
fprintf('  Isp                = %7.2f s \n',Isp)
fprintf('  Fg                 = %7.2f kN \n', Fg/1000)
fprintf('  Fnet               = %7.2f kN \n', Fnet/1000)
fprintf('  Overall Efficiency = %7.0f %% \n\n\n', no*100)

%% 3.3 Compare Turbojet and Turbofan
fprintf('3.3) \n')
fprintf('see performance outputs...\n\n')

%% 3.4 Ideal Turbojet with Afterburner
fprintf('3.4 Turbojet w/Afterburner) \n')

% Given (assume all efficiencies are 100%)
alt = 11e3;                     %m, cruise altitude
M0 = 0.9;                       %cruise mach
mdot0 = 29.17;                  %kg/s, mass flow of air at inlet
mdotAB = 1.17;                  %kg/s, mass flow of fuel in afterburner
T04 = 1330;                     %K, stag pressure at turbine inlet
HV = 44e6;                      %J/kg, heating value of fuel

pid = 1;                        %pt,2/pt,0 = 1; MIL-E-5008B
pic = 18;                       %pt,3/pt,2
pib = 1;                        %pt,4/pt,3
piAB = 1;                       %pt,7/pt,6
pin = 1;                        %pt,9/pt,7

% Constants, Tables
g0 = 9.8067;                    %m/s^2, acceleration of gravity on Earth
R = 286.9;                      %J/kg-K, gas constant for air
gam = 1.4;                      %specific heat ratio air
Cp = gam/(gam-1)*R;             %J/kg-K 
p0static = 22.632E3;            %Pa, static press from std atmo at 11km
T0static = 216.65;              %K, static temp from std atom at 11km
a0 = 295.07;                    %m/s, speed of sound std atmo at 11km
v0 = a0*M0;                     %m/s, flight speed
% pt,5-pt,5AB = 0.05pt,5         frictional losses in afterburner

% i) Free Stream - Station 0
taor = 1+(gam-1)/2*M0^2;                        %Tt,0/T0static
pir = taor^((gam)/(gam-1));                     %Pt,0/P0static
p0 = p0static*pir;                              %Pa, stag press
T0 = T0static*taor;                             %K, stag press
fprintf('Station 0 - Ambient: \n')
fprintf('  Pt,0 = %6.2f kPa \n', p0/1000)
fprintf('  Tt,0 = %6.2f K \n\n', T0)

% ii) Inlet - Station 2
p02 = p0*pid;                                   %Pa, stag press
T02 = T0;                                       %K, stag temp
fprintf('Station 1&2 - Inlet/Compressor Face: \n')
fprintf('  Pt,1 = Pt,2 = %6.2f kPa \n', p02/1000)
fprintf('  Tt,1 = Tt,2 = %6.2f K \n\n', T02)

% iii) Compressor - Station 3; assume isentropic compression
%      Tt,3/Tt,2 = (pt,3/pt,2)^((gam-1)/gam); pt,3/pt,2 = pic = 18
p03 = pic*p02;                                  %Pa, stag press
taoc = pic^((gam-1)/gam);                       %Tt,3/Tt,2
T03 = T02*taoc;                                 %K, stag temp
fprintf('Station 3 - Compressor Exit: \n')
fprintf('  Pt,3 = %6.2f kPa \n', p03/1000)
fprintf('  Tt,3 = %6.2f K \n\n', T03)

% iv) Combustor - Stations 3-4
p04 = pib*p03;                                  %Pa, stag press
T04 = T04;                                      %K, stag temp; given

taolam = T04/T0static;                          %max temp ratio, Tt,4/T0
f = Cp*T0static/HV*(taolam-taor*taoc);          %f/a

fprintf('Station 4 - Turbine Entry: \n')
fprintf('  Pt,4 = %7.2f kPa \n', p04/1000)
fprintf('  Tt,4 = %7.2f K \n\n', T04)

% v) Turbine - Station 5
taot = 1-taor/taolam*(taoc-1);                  %Tt,5/Tt,4
pit = taot^(gam/(gam-1));                       %Pt,5/Pt,4
p05 = p04*pit;                                  %Pa, stag press
T05 = T04*taot;                                 %K, stag temp
fprintf('Station 5 - Turbine Exit: \n')
fprintf('  Pt,5 = %7.2f kPa \n', p05/1000)
fprintf('  Tt,5 = %7.2f K \n\n', T05)

% vi) Afterburner - Station 6
p0AB = p05;                                     %Pa, stag press
%     enthalpy balance across AB: (Kantha)
%     mdotAB*HV = mdotc*Cp(Tt,7-Tt,5) = mdot0*Cp*T0(tao_AB-tao_lam*tao_t)
%     known: mdotAB, HV, mdot0, Cp, T0, tao_lam, tao_t -> find: tao_AB
f_AB = mdotAB/mdot0;                            %f/a in afterburner
X = HV/(Cp*T0static);                          
taolamAB = f_AB*X+(taolam*taot);                %Tt,7/T0, Tt,7/Tt,6 = 1
T0AB = T0static*taolamAB;                       %K, stag temp
fprintf('Station 6 - Afterburner Entry: \n')
fprintf('  Pt,6 = %7.2f kPa \n', p0AB/1000)
fprintf('  Tt,6 = %7.2f K \n\n', T0AB)

% vii) Nozzle Entry - Station 7
p07 = piAB*p0AB;                                %Pa, stag press
T07 = T0AB;                                     %K, stag temp (taoAB = 1)
fprintf('Station 7 - Nozzle Entry: \n')
fprintf('  Pt,7 = %7.2f kPa \n', p07/1000)
fprintf('  Tt,7 = %7.2f K \n\n', T07)

% viii) Nozzle Exit - Station 9; assume perfect expansion
p09 = pin*p07;                                  %Pa, stag press
T09 = T07;                                      %K, stag temp (taon = 1)                              
p9 = p0static;                                  %Pa, static press

X = 2/(gam-1);
Y = (p09/p9)^((gam-1)/gam)-1;
M9 = sqrt(X*Y);                                 %exit Mach
Z = 1+(gam-1)/2*M9^2;
T9 = T09/Z;                                     %K, static temp
fprintf('Station 9 - Nozzle Exit: \n')
fprintf('  Pt,9 = %7.2f kPa \n', p09/1000)
fprintf('  Tt,9 = %7.2f K \n', T09)
fprintf('  P9   = %7.2f kPa \n', p9/1000)
fprintf('  T9   = %7.2f K \n', T9)
fprintf('  M9   = %7.2f \n\n',M9)

% ix) Turbojet w/Afterburner Performance
X = 2/(gam-1);                                  
Y = (taolam/(taor*taoc));                    
Z = (taor*taoc*taot-1);                      
ZZ = (taolamAB/(taor*taoc*taot));              
u9_a0 = (X*Y*Z)^(1/2);                          %exit velocity/free stream speed of sound
u9_a0AB = (X*ZZ*Z)^(1/2);                       %exit velocity (AB)/free stream speed of sound

ST = a0*(u9_a0AB-M0);                           %m/s, specific thrust
f_tot = f+f_AB;                                 %total f/a ratio
SFC = f_tot/ST;                                 %kg/s-N, specific fuel consumption
Isp = 1/(SFC*g0);                               %s, specific impulse

Fr = mdot0*v0;                                  %N, ram drag
Fnet = mdot0*ST;                                %N, net thrust
Fg = Fr+Fnet;                                   %N, gross thrust

nth = 1-1/(taor*taoc);                          %thermal efficiency
np = 2/(1+(u9_a0AB/M0));                        %propulsive efficiency
no = nth*np;                                    %overall efficiency

fprintf('Turbojet w/Afterburner Performance: \n')
fprintf('  Specific Thrust    = %7.2f m/s \n', ST)
fprintf('  SFC                = %7.2f mg/s-N \n', SFC*10^6)
fprintf('  Isp                = %7.2f s \n',Isp)
fprintf('  Fg                 = %7.2f kN \n', Fg/1000)
fprintf('  Fnet               = %7.2f kN \n', Fnet/1000)
fprintf('  Overall Efficiency = %7.0f %% \n\n\n', no*100)