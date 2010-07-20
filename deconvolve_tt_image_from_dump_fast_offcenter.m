function[finemap,source_u,source_v,source_amps,coarse_map,estu_grid,estv_grid]=deconvolve_tt_image_from_dump_fast_offcenter(data_raw,u,v,z,noise_inv,rgrid,fac,chidf_thresh)
if (nargin<8)
    %chidf_thresh=0.5;
    chidf_thresh=-1;
end
if (nargin<7)
    fac=0.5;
end
max_sources=1000;
source_u(max_sources,1)=0;
source_v(max_sources,1)=0;
source_amps(max_sources,1)=0;




%chidf=data_raw'*noise_inv*data_raw/(2*n);
nbeam=size(rgrid,1);
nsource=0;
pad=(nbeam-1)/2;

crap=make_coarse_coarse_r(rgrid,u,v,pad);
crud=sum(abs(crap));
keep_vec=(1:length(crud))';
keep_vec=keep_vec(crud~=0);
u=u(keep_vec);
v=v(keep_vec);
z=z(keep_vec);
rgrid=rgrid(:,:,keep_vec);
big_keep_vec=reshape([keep_vec keep_vec+1]',[2*length(keep_vec) 1]);
data_raw=data_raw(big_keep_vec);
whos

n=max(size(data_raw)/2);
data=data_raw(1:2:2*n);
data=data+i*data_raw(2:2:2*n);




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
max_sources=1000;
mean(abs(data))
chidf=chidf_thresh+1;
while ((nsource <=max_sources) & (chidf>chidf_thresh))
    nsource=nsource+1;
    if(rem(nsource,50)==0)
       disp([nsource mean(abs(data_cur))])
    end
    [a,b]=max(abs(data_cur));
    useu=estu_grid(b);
    usev=estv_grid(b);
    
    new_src_vec=get_src_vec_from_r(1,rgrid,u(b),v(b),u,v,pad);
    new_src_vec_conj=get_src_vec_from_r(1,rgrid,-u(b),-v(b),u,v,pad);
    [c,f]=max(abs(new_src_vec));
    [d,g]=max(abs(new_src_vec_conj));
    if (f>g)
        scale_fac=new_src_vec(f);
    else
        scale_fac=new_src_vec_conj(g);
    end
    %disp(abs(scale_fac))
    scale_fac=rgrid(pad+1,pad+1,b);
    if (scale_fac==0)
        disp(['Error on ' num2str([u(b) v(b)]) ' with value ' num2str(max([c d]))]);
        return;
    end
    finemap(useu,usev);
    src_amp=fac*data_cur(b)/scale_fac;
    source_amps(nsource)=src_amp;
    source_u(nsource)=u(b);
    source_v(nsource)=v(b);
    finemap(useu,usev)=finemap(useu,usev)+fac*data_cur(b)/scale_fac;
    finemap(fine_size(1)+1-useu,fine_size(2)+1-usev)=conj(finemap(useu,usev));
    new_src_vec=get_src_vec_from_r(fac*data_cur(b)/scale_fac,rgrid,u(b),v(b),u,v,pad);
    new_src_vec_conj=get_src_vec_from_r(fac*conj(data_cur(b))/scale_fac,rgrid,-u(b),-v(b),u,v,pad);
    src_amp=fac*data_cur(b)/scale_fac;
    
    
    %coarse_map=realize_fine_grid(finemap,rgrid,estu_grid,estv_grid,pad);
    %data_cur=data-coarse_map;
    data_cur=data_cur-new_src_vec-new_src_vec_conj;
    mean(abs(data_cur));
end
coarse_map=realize_fine_grid(finemap,rgrid,estu_grid,estv_grid,pad);

source_amps=source_amps(1:nsource);
source_u=source_u(1:nsource);
source_v=source_v(1:nsource);
coarse_map_hold=coarse_map;
clear coarse_map;
coarse_map(2:2:2*n)=imag(coarse_map_hold);
coarse_map(1:2:2*n)=real(coarse_map_hold);


