function[deg]=dmsstr2deg(str)
str(str==':')=' ';
crud=big_strtok(str);
if length(crud)>3
    error(['Too man terms in dmsstr2deg with ' num2str(length(crud))]);
end

if sum(crud{1}=='-')>0
    sign=-1;
else
    sign=1;
end


deg=str2num(crud{1});
deg=deg*sign;
fac=1;
for j=2:length(crud),
    fac=fac/60;
    deg=deg+str2num(crud{j})*fac;
end
deg=deg*sign;

    