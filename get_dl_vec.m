function[dl,da,avec]=get_dl_vec(z,h0,om, ok)

if ~exist('h0')
    h0=70;
end
if ~exist('om')
    om=0.27;
end
if ~exist('ok')
    ok=0;
end
%
%if length(z)>1,
%    dl=0*z;
%    da=0*z;
%    for j=1:length(z),
%        [a,b]=get_dl(z(j),h0,om,ok);
%        dl(j)=a;
%        da(j)=b;
%    end
%    return
%end

or=0.42/h0^2;
ol=1-ok-or-om;
n=1e5;
hd=299792.458/h0/1000;


acrit=1/(1+max(z));
da=acrit/200;

avec=1./(1+z);
na=ceil(1-acrit)/da;
da=(1-acrit)/na;

aa=acrit+((-1:(na+1)))*(1-acrit)/na;
dvec=cumsum(dlfun(aa,om,ok,ol,or))*(1-acrit)/na;

%[dc,cnt]=quadl(@dlfun,acrit,1.0,[],[],om,ok,ol,or);
fac=0.5;
dc=interp1(aa+fac*da,dvec,1.0)-interp1(aa+fac*da,dvec,avec);

if (ok>0)
    dm=1/sqrt(ok)*sinh(sqrt(ok)*dc);
else if (ok<0)
        dm=1/sqrt(-1*ok)*sin(sqrt(-1*ok)*dc);
    else
        dm=dc;
    end
end
da=hd*dm./(1+z);
dl=da.*(1+z).^2;

function[dcc]=dlfun(a,om,ok,ol,or)
    adot=a.*sqrt(om*a.^-3+ok*a.^-2+ol+or*a.^-4);
    dcc=1./(a.*adot);
    return
    