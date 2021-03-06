function[finemap,source_u,source_v,source_amps,coarse_map,estu_grid,estv_grid,coarse_map_hold]=deconvolve_pol_image_from_dump_fast(data_raw,u,v,z,noise_inv,rgrid,fac,chidf_thresh)

if (nargin<8)
    chidf_thresh=0.5;
end
if (nargin<7)
    fac=0.5;
end
max_sources=10000;
source_u(max_sources,1)=0;
source_v(max_sources,1)=0;
source_amps(max_sources,1)=0;


n=max(size(data_raw)/2);
data=data_raw(1:2:2*n);
data=data+i*data_raw(2:2:2*n);



%chidf=data_raw'*noise_inv*data_raw/(2*n);
nsource=0;
nbeam=size(rgrid,1);
pad=(nbeam-1)/2;

maxu=max(abs(u));
maxv=max(abs(v));
gridu=( (-maxu-pad):(maxu+pad));
gridv=( (-maxv-pad):(maxv+pad));
intvec=1:max([max(size(gridu)) max(size(gridv))]);
whos gridu
finemap(max(size(gridu)),max(size(gridv)))=0;
fine_size=size(finemap)

estu_grid=u+pad+maxu+1;
estv_grid=v+pad+maxv+1;

data_cur=data;
%max_sources=10;
chidf=chidf_thresh+1;
%mean(abs(data))
sum(sum(abs(data).^2))
while ((nsource <=max_sources) & (chidf>chidf_thresh))
    nsource=nsource+1;
    if(rem(nsource,500)==0)
       %disp([nsource mean(abs(data_cur))])
       disp([nsource sum(sum(abs(data_cur).^2))])
    end
    [a,b]=max(abs(data_cur));
    %useu=gridu(estu_grid(b));
    %usev=gridv(estv_grid(b));
    useu=estu_grid(b);
    usev=estv_grid(b);
    %disp([b u(b) v(b) useu usev estu_grid(b) estv_grid(b)])
    crud=rgrid(pad+1,pad+1,b);
    finemap(useu,usev);
    source_u(nsource)=u(b);
    source_v(nsource)=v(b);

    if (fac==0)
        new_src_vec=get_src_vec_from_r(1,rgrid,u(b),v(b),u,v,pad);
        src_amp=(sum(real(new_src_vec).*real(data_cur))+sum(imag(new_src_vec).*imag(data_cur)))/sum(abs(new_src_vec).^2);
        src_amp=src_amp+i*(sum(real(new_src_vec).*imag(data_cur))-sum(imag(new_src_vec).*real(data_cur)))/sum(abs(new_src_vec).^2);
        new_src_vec=new_src_vec*src_amp;
        source_amps(nsource)=src_amp;
        finemap(useu,usev)=finemap(useu,usev)+src_amp;

    else
        finemap(useu,usev)=finemap(useu,usev)+fac*data_cur(b)/rgrid(pad+1,pad+1,b);
        new_src_vec=get_src_vec_from_r(fac*data_cur(b)/rgrid(pad+1,pad+1,b),rgrid,u(b),v(b),u,v,pad);
        src_amp=fac*data_cur(b)/rgrid(pad+1,pad+1,b);
        source_amps(nsource)=src_amp;
    end
    %coarse_map=realize_fine_grid(finemap,rgrid,estu_grid,estv_grid,pad);
    %data_cur=data-coarse_map;
    
    data_cur=data_cur-new_src_vec;
    %disp([src_amp mean(abs(data_cur))]);    
    %mean(abs(data_cur));
end
source_amps=source_amps(1:nsource);
source_u=source_u(1:nsource);
source_v=source_v(1:nsource);

coarse_map_hold=realize_fine_grid(finemap,rgrid,estu_grid,estv_grid,pad);
%coarse_map_hold=coarse_map;
clear coarse_map;
coarse_map(2:2:2*n)=imag(coarse_map_hold);
coarse_map(1:2:2*n)=real(coarse_map_hold);


