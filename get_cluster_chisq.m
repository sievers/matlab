function[chisq,estmap,mapft,map_real]=get_cluster_chisq(params,func_handle,data,noise_inv,u,v,rgrid,du,maxu,zdump,oversamp,varargin)
x=params(1);
y=params(2);

t_cmb=2.725;


if (nargin<11)
    oversamp=1;
end

if (length(params)==5)
    theta=params(3)*60;
    beta=params(4);
    amp=params(5)/1e3;
else
    amp=params(3)/1e3;
end

nbeam=size(rgrid,1);
pad=(nbeam-1)/2;
npix=2*maxu+nbeam+2;


[mapft,map_real]=feval(func_handle,params,du,npix,oversamp,varargin{:});
mapft=mapft/npix^2/t_cmb;
estmap=realize_fine_grid(mapft,rgrid,u+maxu+pad+1,v+maxu+pad+1,pad);
estmap=im2real(estmap./zdump)';
err=data-estmap;

if (min(size(noise_inv))==1)
    chisq=sum(  (estmap-data).^2./noise_inv.^2);
    targ=sum( (data.^2../noise_inv.^2));
else
    chisq=err'*noise_inv*err;
    targ=data'*noise_inv*data;
end

chisq=chisq-targ;
disp([params chisq])

