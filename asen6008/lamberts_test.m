% Russell Bjella
% Lambert's test

clear all
close all

%% Test 1 - Earth to Venus
launch = 2455450;
arrive = 2455610;
R0 = [147084764.9;-32521189.65;467.1900914;];
Rf = [-88002509.16;-62680223.13;4220331.525];
TOF = arrive - launch;
[V01,Vf1,dnu1,psi1] = lamberts(R0,Rf,TOF,0,1);

%% Test 2 - Mars to Jupiter
launch = 2456300;
arrive = 2457500;
R0 = [170145121.3;-117637192.8;-6642044.272];
Rf = [-803451694.7;121525767.1;17465211.78];
TOF = arrive - launch;
[V02,Vf2,dnu2,psi2] = lamberts(R0,Rf,TOF,0,1);

%% Test 3 - Saturn to Neptune
launch = 2455940;
arrive = 2461940;
R0 = [-1334047119;-571391392.8;63087187.14];
Rf = [4446562425;484989501.5;-111833872.5];
TOF = arrive - launch;
[V03,Vf3,dnu3,psi3] = lamberts(R0,Rf,TOF,0,1);

