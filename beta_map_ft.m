function[mapft,map]=beta_map_ft(params,du,npix,oversamp,varargin)
x=params(1); %x and y are position of cluster in degrees
y=params(2);
theta=params(3)/60; %theta in arcminutes.  Don't ask why different from x,y...
beta=params(4);
amp=params(5)/1e3;  %do amplitude in milliKelvin


%for a2163, beta=0.674, theta=87.5 arcsec from Reese et al.

%get pixel size in real space in degrees
dx=1/du*180/pi/npix;


%oversample the grid to get better resolution.  A small source can
%have some issues if you don't do this.  Factor of 4 works very well,
%smaller ones probably OK too, but haven't messed around with them.

if (nargin<8)
    oversamp=1;
end
npix;
%theta=theta/3600;%convert theta from arcseconds to degrees

pad=(npix-1)/2;

%get x & y positions of grid to be sampled, in degrees
xvals=(-pad*oversamp:pad*oversamp)*dx/oversamp-x;
yvals=(-pad*oversamp:pad*oversamp)*dx/oversamp-y;
npix_eff=2*pad*oversamp+1;
rsq=(repmat(xvals,[npix_eff 1]).^2+repmat(yvals',[1 npix_eff]).^2);
map=amp*(1+rsq/theta^2).^(0.5-1.5*beta);
mapft=fftshift(fft2(ifftshift(map)));
mapft=mapft((npix_eff-1)/2-pad+1:(npix_eff+1)/2+pad,(npix_eff-1)/2-pad+1:(npix_eff+1)/2+pad)/oversamp^2;
%npix_eff
%whos 
if (nargout>1)
    map=map(1:oversamp:size(map,1),1:oversamp:size(map,2));
end
