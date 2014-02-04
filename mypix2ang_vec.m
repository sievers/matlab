function [myphi,mycosdec] = mypix2ang(nside,pix)
%assert(1==0)  %because this shit don't work



%nn=4*nside-1;
%cosdec=1-2*(0.5:(nn))/nn;

nequ=4*nside*(2*nside-1);
ncap=(12*nside*nside-nequ)/2;
inv_4nside=1/4/nside;


cap_fac=1/3/(nside^2);
myphi=0*pix;
mycosdec=0*pix;
twothirds=2/3;

ind=pix<ncap;
myrow=floor(0.5*(-1+sqrt(2*pix(ind)+1)));
mycol=pix(ind)-2*myrow.*(myrow+1);
myphi(ind)=2*pi*(mycol+0.5)./(4*(myrow+1));
mycosdec(ind)=1-cap_fac*(myrow+1).^2;

ind=(pix>=ncap)&(pix<ncap+nequ);
pp=pix(ind)-ncap;
myrow=floor(pp/(4*nside));
mycol=pp-4*nside*myrow;
fac=0.5*ones(size(myrow));
fac(iseven(myrow))=0;
myphi(ind)=2*pi*inv_4nside*(mycol+fac);
mycosdec(ind)=twothirds*(1-4*inv_4nside*(myrow+1));

ind=pix>=(ncap+nequ);
pix(ind)=12*nside*nside-pix(ind)-1;
myrow=floor(0.5*(-1+sqrt(2*pix(ind)+1)));
mycol=pix(ind)-2*myrow.*(myrow+1);
myphi(ind)=2*pi*(mycol+0.5)./(4*(myrow+1));
mycosdec(ind)=1-cap_fac*(myrow+1).^2;
myphi(ind)=2*pi-myphi(ind);
mycosdec(ind)=-1*mycosdec(ind);
%disp([mycosdec myphi/2/pi]);