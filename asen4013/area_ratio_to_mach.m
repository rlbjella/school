function mach2 = area_ratio_to_mach(AoverAstar,gamma)
%BEGINHEADER
% SOURCE
%   /mnt/c/repos/school/asen4013/area_ratio_to_mach.m
% USAGE
%   mach2 = area_ratio_to_mach(AoverAstar,gamma)
% DESCRIPTION
%   Given a ratio of flow area to critical area (where M=1), returns the
%   corresponding supersonic Mach number at the relevant station.
% INPUTS
%   AoverAstar = ratio of area at station to critical area
%   gamma = ratio of specific heats for the gas
% OUTPUTS
%   mach2 = Mach number at station
%ENDHEADER

% Define a range of mach numbers and calculate their corresponding area
% ratios
mach1 = linspace(0,5,10000);
aratio = 1./mach1 .* (2/(gamma+1)*(1+(gamma-1)/2 .* mach1.^2)).^((gamma+1)/(2*(gamma-1)));

% Find where user given area ratio is closest to range of area ratios
tmp = abs(aratio-AoverAstar);
[A,ind] = min(tmp);

% Find mach number at minimum difference
mach2 = mach1(ind);

end

