function[smoothed]=smooth_image(map,npix,varargin)
%function[smoothed]=smooth_image(map,npix,dogauss)
%if (~exist('dogauss'))
%    dogauss='gaussian';
%end

dogauss=get_keyval_default('beam_type','gaussian',varargin{:});
unnorm=get_keyval_default('unnorm',false,varargin{:});

if (~exist('npix'))
    npix=3;
end

nsig=5;
nx=ceil(nsig*npix);
xx=(-nx:nx);
n=length(xx);
dr=repmat(xx.^2,[n 1]);dr=dr+dr';
if (strcmp(dogauss,'gaussian'))
    toconv=exp(-0.5*dr/(npix.^2));
end

if ~unnorm
  toconv=toconv/sum(sum(toconv));
end


if (0)
    smoothed=conv2(map,toconv,'same');
else
    map_copy(size(map,1)+2*nx+1,size(map,2)+2*nx+1)=0;
    na=size(map,1);
    nb=size(map,2);
    map_copy(nx+1:nx+na,nx+1:nx+nb)=map;
    mapft=fft2(map_copy);
    clear map_copy
    
    %toconv_big=0*map_copy;
    toconv_big(size(mapft,1),size(mapft,2))=0;
    aa=ceil(na/2+nx);
    bb=ceil(nb/2+nx);
    toconv_big((aa-nx:aa+nx)+2,(bb-nx:bb+nx)+2)=toconv;
    toconv_big=fftshift(toconv_big);
    toconv_fft=fft2(toconv_big);
    clear toconv_big;
    smoothft=mapft.*toconv_fft;
    clear mapft;
    clear toconv_fft;
    smoothed=ifft2(smoothft);
    if isreal(map)
      smoothed=real(smoothed(nx+1:end-nx-1,nx+1:end-nx-1));
    else
      smoothed=smoothed(nx+1:end-nx-1,nx+1:end-nx-1);
    end
end

