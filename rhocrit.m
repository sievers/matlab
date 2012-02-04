function[rho_c,rho_c_mpc]=rhocrit(z,varargin)
if ~exist('z')
    z=0;
end

h0=get_keyval_default('h0',72,varargin{:});
om=get_keyval_default('om',0.25,varargin{:});
ol=get_keyval_default('ol',1-om,varargin{:});
ok=1-om-ol;

fac=om*(1+z)^3+ok*(1+z)^2+ol;
hz=h0*sqrt(fac);
G=6.67e-8;



hh=hz/(3.08568e19);  %# of km in a megaparsec

rho_c=3*hh^2/(8*pi*G);

rho_c_mpc=rho_c*(3.08568e24)^3/2e33;
