function[rdelt]=get_rdelta(m,delta,z,varargin)
if ~exist('delta')
   delta=500;
end
if ~exist('z')
   z=0;
end

rho=rhocrit(z,varargin{:});
msun=1.98892e33;

rdelt=(msun*m*3/(4*pi*rho*delta))^(1/3);
rdelt=rdelt/3.08568e24;  %convert to mpc
