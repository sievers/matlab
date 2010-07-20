function[map,ra,dec,psfmap,mat,uvmap,upt,vpt]=make_normalized_tt_map_from_pol(fileroot,oversamp,do_scanproj,do_sourceproj)
if (nargin<2)
    oversamp=0;
end
if (nargin<3)
    do_scanproj=0;
end
if (nargin<4)
    do_sourceproj=0;
end

if (do_scanproj|do_sourceproj)
    fid=fopen([fileroot '_NOIS'],'r');
    if (fid==-1)
        disp('gunzipping noise file');
        system(['gunzip -c ' fileroot '_NOIS.gz > ' fileroot '_NOIS']);
    else
        fclose(fid);
    end
    noisemat=read_split_noise([fileroot '_NOIS'],1);
end

if (do_sourceproj)
    fid=fopen([fileroot '_CSRC'],'r');
    if (fid==-1)
        disp('gunzipping proj file');
        system(['gunzip -c ' fileroot '_CSRC.gz > ' fileroot '_CSRC']);
    else
        fclose(fid);
    end
    srcmat=read_split_src([fileroot '_CSRC'],1);
    srcmat=sum(srcmat,3);
end

if (do_scanproj)
    fid=fopen([fileroot '_PROJ'],'r');
    if (fid==-1)
        disp('gunzipping proj file');
        system(['gunzip -c ' fileroot '_PROJ.gz > ' fileroot '_PROJ']);
    else
        fclose(fid);
    end
    projmat=read_split_src([fileroot '_PROJ'],1);

end

[data,u,v,z,nl,np,ra_cent,dec_cent]=read_split_data([fileroot '_SVEC']);
n=1;
while(v(n+1)>=v(n)), 
    n=n+1;
end;
n=n*2;

%noisemat=noisemat(1:n,1:n);
data=data(1:n);
if (do_scanproj|do_sourceproj)
    if (max(size(noisemat))~=length(data))
        warning('noise matrix size mismatch - probably have some weird weight pol/tt issues going on.  Skipping projections');
        do_scanproj=0;
        do_sourceproj=0;
    end
    to_inv=noisemat;
end

if (do_scanproj)
    scan_proj_amp=100;
    to_inv=to_inv+scan_proj_amp*projmat;
    clear projmat;
end
if (do_sourceproj)
    source_proj_amp=1e8;
    to_inv=to_inv+source_proj_amp*srcmat;
end
if (do_scanproj|do_sourceproj)
    disp('inverting projection matrix');
    mat=inv(to_inv);
    clear to_inv;
    data=noisemat*(mat*data);
end


u=u(1:n/2);
v=v(1:n/2);
z=z(1:n/2);
[psf]=read_split_data([fileroot '_PSF']);
psf=psf(1:n);

data=real2im(data);
psf=real2im(psf);
data=data./psf;
data=im2real(data);
psf=im2real(psf);

[uvmap,upt,vpt]=visualize_vec(data,u,v);
psfuvmap=visualize_vec(psf,u,v);

scale_fac=sum(sum(abs(psfuvmap)))/prod(size(psfuvmap));
scale_fac=(2*oversamp+1)^2/scale_fac;

map=fftshift(ifft2(ifftshift(pad_matrix(uvmap,oversamp))))*scale_fac;
psfmap=fftshift(ifft2(ifftshift(pad_matrix(psfuvmap,oversamp))))*scale_fac;


du=find_median_du(u);
dv=find_median_du(v);


nra=size(map,2);
ndec=size(map,1);
ra= (-(nra-1)/2:(nra-1)/2)*180/pi/du/nra;
dec= (-(ndec-1)/2:(ndec-1)/2)*180/pi/dv/ndec;

ra=ra+ra_cent*15;
dec=dec+dec_cent;