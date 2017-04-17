function [elements] = planetary_ephemerides(planet,jde)
% Russell Bjella
% Given a planet and a date in JD, return the orbital elements of a planet.
% Element = a0+a1T+a2T^2+a3T^3

% Housekeeping and input sanitation
planet = lower(planet);
T = (jde-2451545.0)/36525;  % Julian centuries past J2000
AU = 149597870.691;     % Kilometers in an AU
mu_sun = 1.32712440018e11;

% Calculate Meeus elements
if (strcmp(planet,'venus'))
    L = 181.979801+58517.815676*T+0.00000165*T^2-0.000000002*T^3;
    a = 0.72332982;
    e = 0.00677188-0.000047766*T+0.0000000975*T^2+0.00000000044*T^3;
    i = 3.394662-0.0008568*T-0.00003244*T^2+0.000000010*T^3;
    Omega = 76.679920-0.2780080*T-0.00014256*T^2-0.000000198*T^3;
    Pi_peri = 131.563707+0.0048646*T-0.00138232*T^2-0.000005332*T^3;
end
if (strcmp(planet,'earth'))
    L = 100.466449+35999.3728519*T-0.00000568*T^2+0.0*T^3;
    a = 1.000001018;
    e = 0.01670862-0.000042037*T-0.0000001236*T^2+0.00000000004*T^3;
    i = 0+0.0130546*T-0.00000931*T^2-0.000000034*T^3;
    Omega = 174.873174-0.2410908*T+0.00004067*T^2-0.000001327*T^3;
    Pi_peri = 102.937348+0.3225557*T+0.00015026*T^2+0.000000478*T^3;
end
if (strcmp(planet,'mars'))
    L = 355.433275+19140.2993313*T+0.00000261*T^2-0.000000003*T^3;
    a = 1.523679342;
    e = 0.09340062+0.000090483*T-0.0000000806*T^2-0.00000000035*T^3;
    i = 1.849726-0.0081479*T-0.00002255*T^2-0.000000027*T^3;
    Omega = 49.558093-0.2949846*T-0.00063993*T^2-0.000002143*T^3;
    Pi_peri = 336.060234+0.4438898*T-0.00017321*T^2+0.000000300*T^3;
end
if (strcmp(planet,'jupiter'))
    L = 34.351484+3034.9056746*T-0.00008501*T^2+0.000000004*T^3;
    a = 5.202603191+0.0000001913*T;
    e = 0.04849485+0.000163244*T-0.0000004719*T^2-0.00000000197*T^3;
    i = 1.303270-0.0019872*T+0.00003318*T^2+0.000000092*T^3;
    Omega = 100.464441+0.1766828*T+0.00090387*T^2-0.000007032*T^3;
    Pi_peri = 14.331309+0.2155525*T+0.00072252*T^2-0.000004590*T^3;
end
if (strcmp(planet,'saturn'))
    L = 50.077471+1222.1137943*T+0.00021004*T^2-0.000000019*T^3;
    a = 9.554909596-0.0000021389*T;
    e = 0.05550862-0.000346818*T-0.0000006456*T^2+0.00000000338*T^3;
    i = 2.488878+0.0025515*T-0.00004903*T^2+0.000000018*T^3;
    Omega = 113.665524-0.2566649*T-0.00018345*T^2+0.000000357*T^3;
    Pi_peri = 93.056787+0.5665496*T+0.00052809*T^2+0.000004882*T^3;
end
if (strcmp(planet,'uranus'))
    L = 314.055005+429.8640561*T+0.00030434*T^2+0.000000026*T^3;
    a = 19.218446062-0.0000000372*T+0.00000000098*T^2;
    e = 0.04629590-0.000027337*T+0.0000000790*T^2+0.00000000025*T^3;
    i = 0.773196+0.0007744*T+0.00003749*T^2-0.000000092*T^3;
    Omega = 74.005947+0.5211258*T+0.00133982*T^2+0.000018516*T^3;
    Pi_peri = 173.005159+1.4863784*T+0.0021450*T^2+0.000000433*T^3;
end
if (strcmp(planet,'neptune'))
    L = 304.348665+219.8833092*T+0.00030926*T^2+0.000000018*T^3;
    a = 30.110386869-0.0000001663*T+0.00000000069*T^2;
    e = 0.00898809+0.000006408*T-0.0000000008*T^2-0.00000000005*T^3;
    i = 1.769952-0.0093082*T-0.00000708*T^2+0.000000028*T^3;
    Omega = 131.784057+1.1022057*T+0.00026006*T^2-0.000000636*T^3;
    Pi_peri = 48.123691+1.4262677*T+0.00037918*T^2-0.000000003*T^3;
end
if (strcmp(planet,'pluto'))
    L = 238.92903833+145.20780515*T;
    a = 39.48211675-0.00031596*T;
    e = 0.24882730+0.00005170*T;
    i = 17.14001206+0.00004818*T;
    Omega = 110.30393684-0.01183482*T;
    Pi_peri = 224.06891629-0.04062942*T;
end

% Convert angles to radians
L = L*pi/180;
i = i*pi/180;
Omega = Omega*pi/180;
Pi_peri = Pi_peri*pi/180;

% Calculate other orbital elements
omega = Pi_peri - Omega;
M = L - Pi_peri;
Ccen = (2*e-e^3/4+5/96*e^5)*sin(M)+(5/4*e^2-11/24*e^4)*sin(2*M)+(13/12*e^3-43/64*e^5)*sin(3*M)+103/96*e^4*sin(4*M)+1097/960*e^5*sin(5*M);
true = M+Ccen;

% Compute inertial position and velocity
[R,V] = coe2state(a*AU,e,i,Omega*180/pi,omega*180/pi,true*180/pi,mu_sun);
elements = struct('R',R,'V',V,'a',a,'e',e,'i',i,'Omega',Omega,'omega',omega,'true',true);

end
