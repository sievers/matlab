function[dl]=dl_of_z(z,opts)
h=72;
om=0.258;
if exist('opts')
    if isfield(opts,'h')
        h=opts.h;
    end
    if isfield(opts,'om')
        om=opts.om;
    end
end
c_over_h=2.9979e5/h; %(in Mpc)


dl=c_over_h*(1+z).*(eta(1,om)-eta(1./(1+z),om));




function[value]=eta(a,om)
s=((1-om)./om).^(1/3);
value=2*sqrt(s.^3+1)*(a.^(-4) -0.154*s./a.^3+0.4304*s.^2./a.^2+0.19097*s.^3./a+0.066941*s.^4).^(-1/8);
