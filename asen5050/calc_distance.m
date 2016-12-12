function [r_es,r_em,r_ms] = calc_distance(pos_s,pos_m)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen5050/calc_distance.m
% USAGE
%   [r_es,r_em,r_ms] = calc_distance(pos_s,pos_m)
% DESCRIPTION
%   Calculates the distance between the Earth and the spacecraft, Earth and
%   the moon, and the moon and the spacecraft for use in force calculations
% INPUTS
%   a = input [unit]
% OUTPUTS
%   y = output [unit]
%ENDHEADER

% Compute distance
r_es = norm(pos_s);
r_em = norm(pos_m);
r_ms = norm(pos_m - pos_s);

end