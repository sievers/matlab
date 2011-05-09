function[value]=planck_g(freq)
x=6.63e-27*freq*1e9/1.38e-16/2.726;
%value=x./(exp(x)-1);
value=x.^2.*exp(x)./( (exp(x)-1).^2);
