close all
clear all

% Create plot of ideal photodiode curve
arcmins = 44*60:46*60;
theta = arcmins/60;
I_max = 80;   % Short circuit current, microamps
I = I_max * cosd(theta);

figure
hold on
grid on
plot(arcmins,I,'LineWidth',2)
title('Ideal angular response of PDB-C160SM','FontSize',16)
xlabel('Solar incidence angle [arcminutes]','FontSize',16)
ylabel('Current [\mu A]','FontSize',16)

slope = zeros(1,length(arcmins)-1);
for i = 1:length(arcmins)-1
    slope(i)=(I(i+1)-I(i))/(arcmins(i+1)-arcmins(i))
end
avg = mean(slope)*10^3
stddev = std(slope)*10^3
min = min(slope)*10^3
max = max(slope)*10^3
