function [chisq,estmap]=fun(params,data,noise_inv,uvec,vvec,zvec,rgrid,du,finesize)

x=params(1); %x and y are position of cluster in degrees
y=params(2);
%x=0;y=0;
%theta=0.02/60; %theta in arcminutes.  Don't ask why different from x,y...
theta=params(3)/60;
%beta=params(2);
%beta=0.31406;
beta=0.667;
amp=params(4)/1e3;    



oversamp=1;
maxu=max(uvec);
npix=2*maxu+finesize+2;
pad=(npix-1)/2;
t_cmb=2.725;

dx=1/du*180/pi/npix;
xvals=(-pad*oversamp:pad*oversamp)*dx/oversamp-x;
yvals=(-pad*oversamp:pad*oversamp)*dx/oversamp-y;
npix_eff=2*pad*oversamp+1;
rsq=(repmat(xvals,[npix_eff 1]).^2+repmat(yvals',[1 npix_eff]).^2);
map=amp*(1+rsq/theta^2).^(0.5-1.5*beta);
%figure(1);
%surf(map);
mapft=fftshift(fft2(ifftshift(map)));
mapft=mapft((npix_eff-1)/2-pad+1:(npix_eff+1)/2+pad,(npix_eff-1)/2-pad+1:(npix_eff+1)/2+pad)/oversamp^2;


mapft=mapft/npix^2/t_cmb;

%size(mapft)
%size(rgrid)
%size(uvec)

pad=(finesize-1)/2;
estmap=realize_fine_grid(mapft,rgrid,uvec+maxu+pad+1,vvec+maxu+pad+1,pad);
estmap=fix_zdump(estmap,zvec);
estmap=im2real(estmap);

[size(data) size(estmap)];
err=data-estmap';
%chisq=err'*noise_inv*err./(length(data)-2);
chisq=err'*noise_inv*err;
%chisq=sum(err.^2)
disp(num2str([params chisq]));
