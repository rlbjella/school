function jd = utc2jd(year,month,day)
%UTC2JD Summary of this function goes here
%   Detailed explanation goes here

jd = 367*year-floor(7*(year+floor((month+9)/12))/4)+floor(275*month/9);
jd = jd+day+1721013.5;

end

