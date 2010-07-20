function[value]=ctime(tm)
ctime_0=datenum(1969,12,31,19,0,0);
if nargin==0,
  %value=(datenum(now)-ctime_0)*86400;
  value=(now-ctime_0)*86400;
  return;
end
if ischar(tm)
  value=(datenum(tm)-ctime_0)*86400;
  return;
end
