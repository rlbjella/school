function eccentric_anomaly = eccentric_anomaly(mean_anomaly,eccentricity,tolerance)
%BEGINHEADER
% Group 3: Russell Bjella, Tony Ly, Azalee Rafii
% Iterative solver for eccentric anomaly given mean anomaly and
% eccentricity (solve M = E - e*sin(E)) (Kepler's Equation)
% Lab O-1
% Created 3/20/16
% INPUTS:   mean_anomaly = mean anomaly (rads)
%           eccentricity = eccentricity
%           tolerance = minimum delta in eccentric anomaly between two
%           consecutive iterations
% OUTPUTS:  eccentric_anomaly = eccentric anomaly (rads)
%ENDHEADER

M = mean_anomaly;
e = eccentricity;

% Newton Raphson method
% Initial guess E = M (first iteration)
E = M;
Eprev = -1e3;
for i = 1:1e9
    E = E + (M-E+e*sin(E)) ./ (1-e*cos(E));
    if (abs(E-Eprev) <= tolerance)
        break
    end
    Eprev = E;
end

eccentric_anomaly = E;
    
end

