function[myctime]=mjd2ctime(mjd)


%mjd=(myctime-1329696000)/86400+2455977.5;
myctime=  (mjd-2455977.5)*86400+1329696000;