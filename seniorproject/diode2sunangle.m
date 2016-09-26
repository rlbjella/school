function theta_sun = diode2sunangle(ai,bi,ci,di)

% Define max output current for each photodiode
aimax = 1;
bimax = 1;
cimax = 1;
dimax = 1;

% Define photodiode normal vectors 
rt2 = sqrt(2);
a_norm = [rt2;0;-rt2];
b_norm = [rt2;-rt2;0];
c_norm = [rt2;0;rt2];
d_norm = [rt2;rt2;0];

% Compute angle for each photodiode
a_theta = acos(ai/aimax);
b_theta = acos(bi/bimax);
c_theta = acos(ci/cimax);
d_theta = acos(di/dimax);


z_comp = (ci - ai) / (ci + ai);
y_comp = (di - bi) / (di + bi);


end