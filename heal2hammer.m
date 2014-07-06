function[proj,lambda,phi]=heal2hammer(map,dx)
if (1)
  nside=sqrt(numel(map)/12);
  assert(nside==round(nside));
  %x=(0:(nx-1));x=x/max(x);x=x-mean(x);x=4*sqrt(2)*x;
  %y=(0:(nx/2-1));y=y/max(y);y=y'-mean(y);y=2*sqrt(2)*y;
  

  x=(-2+dx:dx:2-dx)*sqrt(2);
  y=(-1+dx:dx:1-dx)*sqrt(2);
  
  nx=numel(x);
  ny=numel(y);

  x=repmat(x,[ny 1]);
  y=repmat(y',[1 nx]);

  sz=size(x);

  nn=numel(x);
  
  x=reshape(x,[1 nn]);
  y=reshape(y,[1 nn]);
  %[min(x) max(x) min(y) max(y)]

  rsqr=(x/sqrt(8)).^2+(y/sqrt(2)).^2;
  ii=(rsqr<=1);
  xx=x(ii);
  yy=y(ii);
  zz=1-(0.25*xx).^2-(0.5*yy).^2;
  zz=sqrt(zz);
  %xx=x(ii);
  %yy=y(ii);

  lambda=2*atan(zz.*xx./(2*(2*zz.^2-1)));
  phi=asin(zz.*yy);

  pix=ang2pix_jls(nside,[pi/2+phi;lambda]);
  dat=map(pix);

  
  crud=0*x;crud(ii)=phi;
  phi=reshape(crud,sz);
  crud=0*x;crud(ii)=lambda;
  lambda=reshape(crud,sz);

  crud=0*x;crud(ii)=dat;
  proj=reshape(crud,sz);

  x=reshape(x,sz);
  y=reshape(y,sz);
  
  %rsqr=(x/sqrt(8)).^2+(y/sqrt(2)).^2;
  %phi(rsqr>1)=nan;
  %lambda(rsqr>1)=nan;



else
  %only for testing purposes
  theta=(-0.49:0.01:0.49)*pi;
  phi=(-0.99:0.01:0.99)*pi;
  tt=repmat(theta,[numel(phi) 1]);
  pp=repmat(phi',[1 numel(theta)]);
  sz=size(tt);
  tt=reshape(tt,[numel(tt) 1]);
  pp=reshape(pp,[numel(pp) 1]);


  x=2*sqrt(2)*cos(tt).*sin(pp/2)./sqrt(1+cos(tt).*cos(pp/2));
  y=sqrt(2)*sin(tt)./sqrt(1+cos(tt).*cos(pp/2));

  z=sqrt(1-(0.25*x).^2-(0.5*y).^2);
  pp2=2*atan(z.*x./(2*(2*z.^2-1)));
  tt2=asin(z.*y);

  mean(mean(abs(pp2-pp)))
  delt=pp2-pp;
  
  mean(mean(abs(tt2-tt)))
  %x=reshape(x,sz);
  %y=reshape(y,sz);

end




