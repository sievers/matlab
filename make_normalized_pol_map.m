function[emap,bmap,ra,dec,psf_emap,psf_bmap,psf_rlmap,psf,egrid_raw,bgrid_raw,upt,vpt,data]=make_normalized_pol_map(fileroot,oversamp,do_scanproj,uvthresh)
if (nargin<2)
    oversamp=0;
end
if (nargin<3)
    do_scanproj=0;
end
if (nargin<4)
    uvthresh=1e5;
end

if (do_scanproj)
    fid=fopen([fileroot '_NOIS'],'r');
    if (fid==-1)
        disp('gunzipping noise file');
        system(['gunzip -c ' fileroot '_NOIS.gz > ' fileroot '_NOIS']);
    else
        fclose(fid);
    end
    noisemat=read_split_noise([fileroot '_NOIS']);
    n=max(size(noisemat))/3;
    noisemat=noisemat(n+1:3*n,n+1:3*n);

    fid=fopen([fileroot '_PROJ'],'r');
    if (fid==-1)
        disp('gunzipping proj file');
        system(['gunzip -c ' fileroot '_PROJ.gz > ' fileroot '_PROJ']);
    else
        fclose(fid);
    end
    projmat=read_split_src([fileroot '_PROJ']);
    projmat=projmat(n+1:3*n,n+1:3*n);

end

[data,u,v,z,nl,np,ra_cent,dec_cent]=read_split_data([fileroot '_SVEC']);
n=length(data)/3;
%data=data(n+1:3*n);
n=n/2;
%u=u(n+1:3*n);
%v=v(n+1:3*n);
%z=z(n+1:3*n);
n=n*2;

if (do_scanproj)
    if (max(size(noisemat))~=2*length(data)/3)
        warning('noise matrix size mismatch - probably have some weird weight pol/tt issues going on.  Skipping projections');
        do_scanproj=0;
        do_sourceproj=0;
    end
end

if (do_scanproj)
    scan_proj_amp=100;
    disp('inverting projection matrix');
    projmat=inv(noisemat+scan_proj_amp*projmat);
    data_pol=data(n+1:3*n);
    data_pol=noisemat*(projmat*data_pol);
    data(n+1:3*n)=data_pol;
end


[psf]=read_split_data([fileroot '_PSF']);
%psf=psf(n+1:3*n);

%normalize by the psf
data=real2im(data);
psf=real2im(psf);
%data=data./psf;
data=im2real(data);
psf=im2real(psf);



whos
[egrid_raw,bgrid_raw,upt,vpt,rl]=visualize_pol(data,u,v,0);
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