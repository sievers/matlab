function[val,val2]=sz_amp_nu(nu)

h=6.63e-27;
k=1.38e-16;
T=2.725;
x=h*nu/k/T*1e9; %frequency in GHz
fac1=x.*exp(x)./(exp(x)-1);
fac2=x.*coth(x/2)-4;
%val=x.*exp(x)./((exp(x)-1).^1).*(x.*coth(x/2)-4);


val=fac1.*fac2.*planck_g(nu);
val2=x*(exp(x)+1)/(exp(x)-1)-4;
%val=fac1.*fac2;




%function[val]=sz_amp_nu(nu)

%h=6.63e-27;
%k=1.38e-16;
%T=2.725;
%x=h*nu/k/T*1e9; %frequency in GHz
%fac1=x.*exp(x)./(exp(x)-1);
%fac2=x.*coth(x/2)-4;
%%val=x.*exp(x)./((exp(x)-1).^1).*(x.*coth(x/2)-4);
%val=fac1.*fac2.*planck_g(nu);

