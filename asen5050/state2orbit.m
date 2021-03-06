function elements = state2orbit(R,V,mu,deg)
%BEGINHEADER
% state2orbit.m
% USAGE
%   elements = state2elms(R,V,398600.44)
% DESCRIPTION
%   Given a position vector and a velocity vector of a satellite, and the
%   gravitational parameter of the central body, returns a MATLAB structure 
%   containing a variety of orbital characteristics, including the
%   classical orbital elements.
% INPUTS
%   R = position vector (X,Y,Z) [km]
%   V = velocity vector (Vx,Vy,Vz) [km]
%   mu = gravitational parameter [km^3/s^2]
%   deg = if set to a none zero/null value, returns results in degrees
%         instead of radians
% OUTPUTS
%   elements = a struct containing the following orbital characteristics:
%       a = semimajor axis [km]
%       e = eccentricity
%       i = inclination [rad]
%       raan = right ascension of ascending node [rad]
%       omega = argument of periapsis [rad]
%       theta = true anomaly [rad]
%       mean = mean anomaly [rad]
%       ecc = eccentric anomaly [rad]
%       t_p = time past periapsis [s]
%       T = orbital period [s]
%       p = semilatus rectum [km]
%       alt_max = maximum altitude above surface [km]
%       alt_min = minimum altitude above surface [km]
%       energy = specific energy per unit mass of satellite
%       h = magnitude of specific angular momentum vector [km^2/s^2]
%       hx = x component of specific angular momentum vector [km^2/s^2]
%       hy = y component of specific angular momentum vector [km^2/s^2]
%       hz = z component of specific angular momentum vector [km^2/s^2]
%       phi_fpa = flight path angle [rad]
%       r = magnitude of position vector [km]
%       v = magnitude of velocity vector [km/s]
%ENDHEADER

if (length(R) ~= 3 || length(V) ~= 3)
    printf('ERROR: Inputs need to be vectors of length 3!\n');
end

% Earth radius
%%%%%%%% TODO %%%%%%%%%
% Add support for altitude above other central bodies
RE = 6378;      % [km]

% Calculate distance and speed
r = norm(R);
v = norm(V);
% Calculate radial velocity and specific angular momentum
v_r = dot(R,V) / r;
H = cross(R,V);
h = norm(H);
hx = H(1);  hy = H(2);  hz = H(3);
% Calculate inclination
i = acos(H(3)/h);
% Calculate node line
N = cross([0 0 1],H);
Nmag = norm(N);
% Calculate right ascension of ascending node
if (N(2) >= 0)
    Omega = acos(N(1)/Nmag);
else
    Omega = 2*pi - acos(N(1)/Nmag);
end
% Calculate eccentricity
E = (1/mu)*(cross(V,H) - (mu/r)*R);
e = norm(E);
% Calculate argument of perigee
if (E(3) >= 0)
    omega = acos(dot(N,E)/(Nmag*e));
else
    omega = 2*pi - acos(dot(N,E)/(Nmag*e));
end
% Calculate true anomaly
if (v_r >= 0)
    theta = acos(dot(E/e,R/r));
else
    theta = 2*pi - acos(dot(E/e,R/r));
end
% Calculate energy per unit mass
energy = v^2/2 - mu/r;      % [km^2/s^2]
% Calculate semimajor axis, orbital period, semiparameter, and mean motion
p = h^2/mu;         % semilatus rectum [km]
a = p/(1-e^2);      % semimajor axis [km]
T = 2*pi*sqrt(a^3/mu);      % orbital period [s]
n = 2*pi/T;     % mean motion [rad/s]
% Calculate other anomalies and time past periapsis
[~,ecc,mean,t_p]=anomalies(theta,'true',a,e,mu,0);
% Calculate flight path angle
cos_phi = h/(r*v);
if (true > pi)
    phi_fpa = -acos(cos_phi);
else
    phi_fpa = acos(cos_phi);
end
% Calculate radius of apoapsis and periapsis, as well as max and min alt
r_a = a*(1+e);
alt_max = r_a - RE;
r_p = a*(1-e);
alt_min = r_p - RE;

% Convert to degrees if input parameter is set
if(deg)
    theta = rad2deg(theta);
    mean = rad2deg(mean);
    ecc = rad2deg(ecc);
    Omega = rad2deg(Omega);
    omega = rad2deg(omega);
    n = rad2deg(n);
    phi_fpa = rad2deg(phi_fpa);
    i = rad2deg(i);
end

% Write characteristics to structure
elements = struct('a',a,'e',e,'i',i,...
    'raan',Omega,'omega',omega,'true',theta,'mean',mean,...
    'ecc',ecc,'t_p',t_p,'P',T,'p',p,'n',n,'r_a',r_a,'r_p',r_p,...
    'alt_max',alt_max,'alt_min',alt_min,'energy',energy,...
    'h',h,'hx',hx,'hy',hy,'hz',hz,'phi_fpa',phi_fpa,...
    'r',r,'rx',R(1),'ry',R(2),'rz',R(3),'v',v,'vx',V(1),'vy',V(2),...
    'vz',V(3),'mu',mu);

end

