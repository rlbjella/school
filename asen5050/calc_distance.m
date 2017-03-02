function [r_es,r_em,r_ms] = calc_distance(pos_s,pos_m)
% Russell Bjella
% ASEN 5050 Final Project
% Three body integrator
% Distance calculator

% Compute distance
r_es = norm(pos_s);
r_em = norm(pos_m);
r_ms = norm(pos_m - pos_s);

end