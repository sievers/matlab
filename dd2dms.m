function[deg,min,sec]=dd2dms(dec)
sign=1;
if (dec<0)
    sign=-1;
    dec=-1*dec;
end
deg=floor(dec);
dec=60*(dec-deg);
min=floor(dec);
sec=60*(dec-min);

deg=sprintf('%02d',deg);
if (sign==1)
    deg=['+' deg];
else
    deg=['-' deg];
end
min=sprintf('%02d',min);
sec=sprintf('%06.3f',sec);

