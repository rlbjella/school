function [V0,Vf,dnu,psi] = lamberts(R0,Rf,TOF,revs,type)
% Russell Bjella
% ASEN 6008
% Feb 7 2017
% Lambert's Solver - Universal Variables Formulation

% Define tolerance and gravitational parameter
tol = 1e-6;
tol_psi = 1e-6;
mu = 1.32712440018e11;  % Sun
TOF = TOF*86400;

% Initialize
r0 = norm(R0);
rf = norm(Rf);
cos_dnu = dot(R0,Rf)/abs(r0*rf);
nu1 = atan2(R0(2),R0(1));
nu2 = atan2(Rf(2),Rf(1));
dnu = (nu2-nu1);
if (dnu < 0)
    dnu = dnu + 2*pi;
end
if (dnu < pi)
    DM = 1;
else
    DM = -1;
end
% Check ability to compute trajectory
A = DM*sqrt(r0*rf*(1+cos_dnu));
if (dnu == 0 || A == 0)
    error('ERROR - trajectory cannot be computed.\n Check position inputs.')
end
% Initialize psi and c coefficients
if (revs == 0)
    psi = 0;
    psi_up = 4*pi^2;
    psi_low = -4*pi;
elseif (revs > 0)
    %psi_up = 4*(revs+1)^2*pi^2;
    if (type == 3)
        psi_up = 80;
    else
        psi_up = 4*(revs+1)^2*pi^2;
    end
    psi_low = 4*revs^2*pi^2;
    if (type == 3)
        psi = psi_low+1;
    else
        psi = psi_low;
    end
else
    error('revs must be greater than or equal to zero.\n')
end
c2 = 1/2;
c3 = 1/6;

% Iterate on psi
dt = 0;     % Initialize solved time of flight
loop = 0;
while (abs(dt - TOF) > tol)
    % Increase tolerance if necessary
    loop = loop + 1;
    if (loop == 1000)
        warning('Tolerance increased to 1E-5')
        tol = 1e-5;
    elseif (loop == 10000)
        warning('Tolerance increased to 1E-4')
        tol = 1e-4;
    elseif (loop == 100000)
        warning('Tolerance increased to 1E-3')
        tol = 1e-3;
    elseif (loop == 1000000)
        error('NO CONVERGENCE');
    end
    y = r0 + rf + A*(psi*c3-1)/sqrt(c2);
    % If y < 0, adjust psi_low until y > 0
    if (A > 0.0 && y < 0.0)
        while (y < 0.0)
            psi = psi + 0.1;
            y = r0 + rf + A*(psi*c3-1)/sqrt(c2);
        end
    end
    % Formulate universal variable
    xi = sqrt(y/c2);
    dt = (xi^3*c3+A*sqrt(y))/sqrt(mu);
    DELTA = (dt - TOF)/86400;
    if (dt <= TOF && type == 3)
        % If on right branch, move left
        psi_up = psi;
        psi = (psi_up+psi_low)/2;
    elseif (dt >= TOF && type == 3)
        psi_low = psi;
        psi = psi + 1;
    elseif (dt <= TOF)
        psi_low = psi;
        psi = (psi_up+psi_low)/2;
    elseif (dt >= TOF)
        psi_up = psi;
        psi = (psi_up+psi_low)/2;
    end
    DELTA = (dt - TOF)/86400;
    if (psi > tol_psi)
        c2 = (1-cos(sqrt(psi)))/psi;
        c3 = (sqrt(psi)-sin(sqrt(psi)))/sqrt(psi^3);
    elseif (psi < -1*tol_psi)
        c2 = (1-cosh(sqrt(-psi)))/psi;
        c3 = (sinh(sqrt(-psi))-sqrt(-psi))/sqrt((-psi)^3);
    else 
        c2 = 1/2;
        c3 = 1/6;
    end
end

% Compute
f = 1 - y/r0;
gdot = 1 - y/rf;
g = A*sqrt(y/mu);

% Output
V0 = (Rf - f*R0)/g;
Vf = (gdot*Rf - R0)/g;

        
            
end

