function[y]=offset_lognormal(params,x)
%Calculate the offset-lognormal distribution
%BTW, if you want to re-scale x (e.g. x->x/fac), params(3)->params(3)/fac,
%params(1)->params(1)-log(fac)
%also, cdf is:  0.5*(1+erf( (log(x-dx)-(cent+sig^2))/sqrt(2)/sig)
%Also, if you want to *generate* variables,
%x=exp(erfinv(2*rand-1)*sqrt(2)*sig+a+sig^2)+dx
%better, x= exp(randn*sig+cent+sig^2)+dx

cent=params(1);
sig=params(2);
dx=params(3);
vec=cent+dx;

sig=sig/(vec);
xx=log(x+dx);
y=exp(-0.5*(xx-log(cent+dx)).^2./sig^2);
yy=imag(y);
y(abs(yy)>0)=0;
y(isinf(y))=0;
