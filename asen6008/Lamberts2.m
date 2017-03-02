% Interplanetary Mission Design
%
%
% Universal Variables Lambert Algorithm
%
%
% Function inputs
%       r0 = initial position vector
%       rf = final position vector
%       dt = time of flight
%       revs = 1 for single revs, >1 for multi rev.
%       mu = gravitational parameter of central body
%
% Function outputs
%       v0 = initial velocity at r0
%       vf = final velocity at rf
%       psi_n = value of psi converged
%       Type = type I/II converged
%
%
%   NOTE: For multi rev solutions, see note on line 114.
%
%
% By Eduardo J. Villalba
%


function [v0 vf psi_n Type] = Lamberts2(r0,rf,dt,revs,mu)

tol_psi = 1e-6;
tol_dt = 1e-6;

nu1 = atan2(r0(2),r0(1));
nu2 = atan2(rf(2),rf(1));
delta_nu = nu2-nu1;
if delta_nu < 0
    delta_nu = delta_nu + 2*pi;
end


% TM = Transfer Method (+1 short way, -1 long way)
% Direction of motion dictaded by delta_mu
if delta_nu > pi
    TM = -1;
    Type = 2;
else
    TM = 1;
    Type = 1;
end
% delta_nu*180/pi

cos_delnu = dot(r0,rf)/abs(norm(r0)*norm(rf));
% cos_delnu = cos(delta_nu);
A = TM*sqrt(norm(r0)*norm(rf)*(1+cos_delnu));

if acos(cos_delnu) == 0 || A == 0
    error('Trajectories cannot be computed')
end

c2 = 1/2;
c3 = 1/6;
if revs == 0
    psi_n = 0;
    psi_up = 4*pi^2;
    psi_low = -6*pi;
elseif revs > 0
    psi_up  = 4*(revs+1)^2*pi^2;% ((2*(revs+1))*pi)^2;
    psi_low = 4*revs^2*pi^2; % ((2*(revs))*pi)^2;
    psi_n = (psi_up + psi_low)/2;
else
    error('Number of revolutions should be zero or positve')
end

% NOTE: The nominal psi value, psi_n, needs to change according to what
% type of trajectory we are dealing with.

% for i = 1:10
loop_count = 0;
while true
    loop_count = loop_count +1;
    if loop_count == 1000
        warning('TOLERANCE INCREASED TO 1E-5')
        tol_dt = 1e-5;
    elseif loop_count == 10000
        warning('TOLERANCE INCREASED TO 1E-4')
        tol_dt = 1e-4;
    elseif loop_count == 30000
        warning('TOLERANCE INCREASED TO 1E-3')
        tol_dt = 1e-3;
    elseif loop_count == 60000
        warning('TOLERANCE INCREASED TO 1E-2')
        tol_dt = 1e-2;
    elseif loop_count == 100000
        fprintf('Lamberts did not converge for TOF of %d \n',dt/86400)
        abs(dt_n - dt)
        error('NO CONVERGENCE')
    end

    y = norm(r0) + norm(rf) + A*(psi_n*c3 - 1)/sqrt(c2);
    
    if A > 0 && y < 0 % readjusting psi_low until y > 0
%         disp('special case')
        
        while y < 0
            psi_n = psi_n + 0.1;
            y = norm(r0) + norm(rf) + A*(psi_n*c3 - 1)/sqrt(c2);
        end
        
    end
    
    Xi = sqrt(y/c2);
    dt_n = (Xi^3*c3 + A*sqrt(y))/sqrt(mu);
    
    % NOTE: For multirev, the bisection method needs to account for the
    % fact that there is a portion of the TOF vs. Psi relationship that has
    % a negative slope. Therefore the bisection method is essentially
    % flipped. So the logic below changes from "dt_n <= dt" to "dt_n >= dt"
    
    if dt_n <= dt % or dt_n => dt for "left side" multirev
        psi_low = psi_n;
    else
        psi_up = psi_n;
    end
    
    psi_n = (psi_up + psi_low)/2;
    
    if psi_n > tol_psi
        c2 = (1 - cos(sqrt(psi_n)))/psi_n;
        c3 = (sqrt(psi_n) - sin(sqrt(psi_n)))/sqrt(psi_n^3);
    elseif psi_n < -tol_psi
        c2 = (1 - cosh(sqrt(-psi_n)))/psi_n;
        c3 = (sinh(sqrt(-psi_n)) - sqrt(-psi_n))/sqrt((-psi_n)^3);
    else
        c2 = 1/2;
        c3 = 1/6;
    end
    
    if abs(dt_n - dt) < tol_dt
        break
    end
end

f = 1 - y/norm(r0);
gdot = 1 - y/norm(rf);
g = A*sqrt(y/mu);

v0 = (rf - f*r0)/g;
vf = (gdot*rf - r0)/g;