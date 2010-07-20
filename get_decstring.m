function[str]=get_decstring(dec)
if (dec<0)
    sign=-1;
    dec=-1*dec;
else
    sign=1;
end
eps=1;
dec=dec+eps/3600;


dd=floor(dec);
dec=(dec-dd)*60;
dm=floor(dec);
ds=round((dec-dm)*60-eps);

dd=dd*sign;
str='$';
str=sprintf('%s%02d^o',str,dd);

%if ((dm~=0)|(ds~=0))
    str=sprintf('%s%02d''',str,dm);
%end
if (ds~=0)
    str=sprintf('%s%02d"',str,ds);
end
str=sprintf('%s$',str);

