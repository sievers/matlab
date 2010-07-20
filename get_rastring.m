function[str]=get_rastring(ra)
eps=1e-3;
ra=ra+eps/3600;
rah=floor(ra);
ra=(ra-rah)*60;
ram=floor(ra);
ras=round((ra-ram)*60-eps);


str='$';
str=sprintf('%s%02d^h',str,rah);

if ((ram~=0)|(ras~=0))
    str=sprintf('%s%02d''',str,ram);
end
if (ras~=0)
    str=sprintf('%s%02d"',str,ras);
end
str=sprintf('%s$',str);

