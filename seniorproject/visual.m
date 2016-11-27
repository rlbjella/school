%% Visualize all the shit
% Assumes the following configuration:
%       y           a | b
%       |           -----
%       |___x       d | c

% HK
clear all
close all
% Const
cos45 = sqrt(2)/2;

% Plot
figure(1);hold on;grid on;
% Photodiode array coordinate system
quiver3(0,0,0,1,0,0,'k');quiver3(0,0,0,0,1,0,'k');quiver3(0,0,0,0,0,1,'k');
xlabel('X');ylabel('Y');zlabel('Z');
axis([-1.25 1.25 -1.25 1.25 0 1.25]);
% Photodiode A
quiver3(-0.1,0.1,0.1,-0.5,0.5,cos45,'r');
% Photodiode B
quiver3(0.1,0.1,0.1,0.5,0.5,cos45,'b');
% Photodiode C
quiver3(0.1,-0.1,0.1,0.5,-0.5,cos45,'g');
% Photodiode D
quiver3(-0.1,-0.1,0.1,-0.5,-0.5,cos45,'m');
