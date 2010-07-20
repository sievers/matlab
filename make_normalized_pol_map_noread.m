function[emap,bmap,ra,dec,psf_emap,psf_bmap,psf_rlmap,psf,egrid_raw,bgrid_raw,upt,vpt,data]=make_normalized_pol_map(data,fileroot,oversamp,uvthresh)
if (nargin<3)
    oversamp=0;
end
if (nargin<4)
    uvthresh=1e5;
end

[data_raw,u,v,z,nl,np,ra_cent,dec_cent]=read_split_data([fileroot '_SVEC']);
if (length(data)<2*length(u))
    %need to fill out the data
    data_hold=data;
    n=length(data)/2;
    clear data;
    data(n+1:3*n)=data_hold;
end

if (size(data,1)==1)
    data=data';
end


[psf]=read_split_data([fileroot '_PSF']);
%psf=psf(n+1:3*n);

%normalize by the psf
whos
data=real2im(data);
psf=real2im(psf);
%data=data./psf;
data=im2real(data);
psf=im2real(psf);



%whos
[egrid_raw,bgrid_raw,upt,vpt,rl]=visualize_pol(data,u,v,0);
whos
[psf_egrid,psf_bgrid,upt,vpt,psf_rl]=visualize_pol(psf,u,v,0);

%uvthresh=160;

egrid=uvtrim(egrid_raw,uvthresh,upt,vpt);
bgrid=uvtrim(bgrid_raw,uvthresh,upt,vpt);

psf_egrid=uvtrim(psf_egrid,uvthresh,upt,vpt);
psf_bgrid=uvtrim(psf_bgrid,uvthresh,upt,vpt);
psf_rlgrid=uvtrim(psf_rl,uvthresh,upt,vpt);

%calculate normalization factor
scale_fac=sum(sum(abs(psf_rlgrid)))/prod(size(psf_rlgrid));
crud=im2real(psf);
r=sqrt(u.^2+v.^2);
crud=crud(r<uvthresh);

disp([sum(sum(abs(psf_rlgrid))) sum(abs(crud)) scale_fac]);
scale_fac=(2*oversamp+1)^2/scale_fac;




emap=fftshift(ifft2(ifftshift(pad_matrix(egrid,oversamp))))*scale_fac;
bmap=fftshift(ifft2(ifftshift(pad_matrix(bgrid,oversamp))))*scale_fac;

psf_emap=fftshift(ifft2(ifftshift(pad_matrix(psf_egrid,oversamp))))*scale_fac;
psf_bmap=fftshift(ifft2(ifftshift(pad_matrix(psf_bgrid,oversamp))))*scale_fac;
psf_rlmap=fftshift(ifft2(ifftshift(pad_matrix(psf_rl,oversamp))))*scale_fac;


du=find_median_du(u);
dv=find_median_du(v);


nra=size(emap,2);
ndec=size(emap,1);
ra= (-(nra-1)/2:(nra-1)/2)*180/pi/du/nra;
dec= (-(ndec-1)/2:(ndec-1)/2)*180/pi/dv/ndec;

ra=ra+ra_cent*15;
dec=dec+dec_cent;