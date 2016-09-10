function [true,ecc,mean,time,r] = anomalies(value,unit,a,e,mu,deg)
%BEGINHEADER
% state2orbit.m
% USAGE
%   [true,ecc,mean,time]=anomalies(25,'true',15000,0.1,398600.44)
% DESCRIPTION
%   Given the value of true anomaly, eccentric anomaly, mean anomaly, or time
%   (including its unit) return the vector of all four values given the
%   semimajor axis, eccentricity, and gravitational parameter of the orbit.
% INPUTS
%   value = the decimal value of one of the anomalies or time past
%   periapsis in degrees or seconds, respectively
%   unit = 'true', 'ecc', 'mean', or 'time' to indicate which of the four
%   possible inputs is being used
%   a = the semimajor axis of the orbit in kilometers
%   e = the eccentricity of the orbit
%   mu = the gravitational parameter of the central body in km^3/s^2
%   deg = if set to a none zero/null value, returns results in degrees
%         instead of radians
% OUTPUTS
%   true = true anomaly [deg]
%   ecc = eccentric anomaly [deg]
%   mean = mean anomaly [deg]
%   time = time past periapsis [s]
%   r = radius (magnitude of position vector) [km]
%ENDHEADER

%% Interpret input unit and perform initial calculations
unit = lower(unit);
if (strcmp(unit,'eccentric'))
    unit = 'eccentric';
end
% Sanity check inputs
%%%%%%%%% TO DO %%%%%%%%%%
T = 2*pi*sqrt(a^3/mu);  % orbital period [s]
n = 2*pi/T;     % mean motion [deg/s]
p = a*(1-e^2);

%% Perform conversion between anomalies
if (strcmp(unit,'true'))
    % Given true anomaly
    true = deg2rad(value);   
    % Get the sine and cosine of the eccentric anomaly for quadrant check
    sin_E = (sin(true)*sqrt(1-e^2))/(1+e*cos(true));
    cos_E = (e+cos(true))/(1+e*cos(true));
    ecc = atan2(sin_E,cos_E);     % atan2 finds the correct quadrant
    if (ecc < 0) 
        ecc = 2*pi + ecc;
    end
    mean = ecc - e*sin(ecc);       % Kepler's equation to get mean anomaly
    time = mean/n;
    r = a*(1 - e*cos(ecc));      % magnitude of position vector
    if(deg)
        true = rad2deg(true);
        mean = rad2deg(mean);
        ecc = rad2deg(ecc);
    end
elseif (strcmp(unit,'ecc'))
    % Given eccentric anomaly
    ecc = deg2rad(value);
    mean = ecc - e*sin(ecc);   % Kepler's equation to get mean anomaly
    time = mean/n;
    r = a*(1 - e*cos(ecc));      % magnitude of position vector
    sin_T = (sin(ecc)*sqrt(1-e^2))/(1-e*cos(ecc));
    cos_T = (cos(ecc) - e)/(1 - e*cos(ecc));
    true = atan2(sin_T,cos_T);
    if (true < 0) 
        true = 2*pi + true;
    end
    if(deg)
        true = rad2deg(true);
        mean = rad2deg(mean);
        ecc = rad2deg(ecc);
    end
elseif (strcmp(unit,'mean'))
    % Given mean anomaly
    mean = deg2rad(value);
    time = mean/n;     % trivial conversion to time past periapsis
    % Newton Raphson method
    % Initial guess E = M (first iteration)
    ecc = mean;
    if (e > 0.75)
        printf('WARNING: applying Newton-Raphson method to highly eccentric orbit.\n');
        printf('Given eccentricity: %f\n'+e);
    end
    Eprev = -1e3;
    for i = 1:1e9
        ecc = ecc + (mean-ecc+e*sin(ecc)) ./ (1-e*cos(ecc));
        if (abs(ecc-Eprev) <= 0.00001)
            break
        end
        Eprev = ecc;
    end
    r = a*(1 - e*cos(ecc));      % magnitude of position vector
    sin_T = (sin(ecc)*sqrt(1-e^2))/(1-e*cos(ecc));
    cos_T = (cos(ecc) - e)/(1 - e*cos(ecc));
    true = atan2(sin_T,cos_T);
    if (true < 0) 
        true = 2*pi + true;
    end
    if(deg)
        true = rad2deg(true);
        mean = rad2deg(mean);
        ecc = rad2deg(ecc);
    end
elseif (strcmp(unit,'time'))
    % Given time past periapsis
    time = value;
    mean = n*(time);   % trivial conversion to mean anomaly
    % Newton Raphson method
    % Initial guess E = M (first iteration)
    ecc = mean;
    if (e > 0.75)
        printf('WARNING: applying Newton-Raphson method to highly eccentric orbit.\n');
        printf('Given eccentricity: %f\n'+e);
    end
    Eprev = -1e3;
    for i = 1:1e9
        ecc = ecc + (mean-ecc+e*sin(ecc)) ./ (1-e*cos(ecc));
        if (abs(ecc-Eprev) <= 0.00001)
            break
        end
        Eprev = ecc;
    end
    sin_T = (sin(ecc)*sqrt(1-e^2))/(1-e*cos(ecc));
    cos_T = (cos(ecc) - e)/(1 - e*cos(ecc));
    true = atan2(sin_T,cos_T);
    if (true < 0) 
        true = 2*pi + true;
    end
    r = a*(1 - e*cos(ecc));      % magnitude of position vector
    if(deg)
        true = rad2deg(true);
        mean = rad2deg(mean);
        ecc = rad2deg(ecc);
    end
else
    % Invalid input argument
    printf('Invalid input unit: '+unit+'\n');
    [true,ecc,mean,time,r] = [0,0,0,0,0];
end



end

