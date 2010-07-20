function[dl,da]=get_dl(z,h0,om, ok)

if ~exist('h0')
    h0=70;
end
if ~exist('om')
    om=0.27;
end
if ~exist('ok')
    ok=0;
end

if length(z)>1,
    dl=0*z;
    da=0*z;
    for j=1:length(z),
        [a,b]=get_dl(z(j),h0,om,ok);
        dl(j)=a;
        da(j)=b;
    end
    return
end

or=0.42/h0^2;
ol=1-ok-or-om;
n=1e5;
hd=299792.458/h0/1000;

if (1)
    acrit=1/(1+z);
    [dc,cnt]=quadl(@dlfun,acrit,1.0,1e-10,[],om,ok,ol,or);
    %disp([dc cnt])
    
    %da=0.0001;
    %aa=acrit:da:1;
    %adot=aa.*sqrt(om./aa.^3+ok./aa.^2+ol+or./aa.^4);
    %dc=sum(1./(aa.*adot))*da
    
    
       
    
else
    
    dcc=0;
    dtt=0;
    imin=1/(1+z)*n
    for i=n:-1:imin,
        a=(i-0.5)/n;
        adot=a*sqrt(om/a^3+ok/a^2+ol+or/a^4);
        dcc=dcc+1/(a*adot*n);
        dtt=dtt+1/adot/n;
        if (a>1/(1+z)),
            dc=dcc;
            dt=dtt;
        end
    end
    disp(dc)
end

if (ok>0)
    dm=1/sqrt(ok)*sinh(sqrt(ok)*dc);
else if (ok<0)
        dm=1/sqrt(-1*ok)*sin(sqrt(-1*ok)*dc);
    else
        dm=dc;
    end
end
da=hd*dm/(1+z);
dl=da*(1+z)^2;

function[dcc]=dlfun(a,om,ok,ol,or)
    adot=a.*sqrt(om*a.^-3+ok*a.^-2+ol+or*a.^-4);
    dcc=1./(a.*adot);
    return
    