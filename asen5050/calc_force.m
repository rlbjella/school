function [F_es,F_em,F_ms] = calc_force(pos_s,pos_m)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/schoo/asen5050/calc_force.m
% USAGE
%   [F_es,F_em,F_ms] = calc_force(pos_s,pos_m)
% DESCRIPTION
%   Given position vectors of a spacecraft and the moon, compute the
%   gravitational force of the Earth on both as well as the force exerted
%   by the moon on the satellite
% INPUTS
%   a = input [unit]
% OUTPUTS
%   y = output [unit]
%ENDHEADER