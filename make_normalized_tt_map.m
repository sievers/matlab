function[map,ra,dec,psfmap,mat,uvmap,upt,vpt]=make_normalized_tt_map(fileroot,oversamp,do_noise,do_scanproj,do_sourceproj)

%do get a properly oriented map, do
%imagesc(ra,dec,flipud(fliplr(map')));set(gca,'Ydir','normal','Xdir','reverse');
if (~exist('oversamp'))
    oversamp=0;
end
if (~exist('do_scanproj'))
    do_scanproj=0;
end
if (~exist('do_sourceproj'))
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
    noisemat=read_split_noise([fileroot '_NOIS']);
end

if (do_sourceproj)
    fid=fopen([fileroot '_CSRC'],'r');
    if (fid==-1)
        disp('gunzipping proj file');
        system(['gunzip -c ' fileroot '_CSRC.gz > ' fileroot '_CSRC']);
    else
        fclose(fid);
    end
    srcmat=read_split_src([fileroot '_CSRC']);
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
    projmat=read_split_src([fileroot '_PROJ']);

end

[data,u,v,z,nl,np,ra_cent,dec_cent]=read_split_data([fileroot '_SVEC']);
n=length(data);

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

[psf]=read_split_data([fileroot '_PSF']);

data=real2im(data);
psf=real2im(psf);
%data=data./psf;
data=im2real(data);
psf=im2real(psf);

[uvmap,upt,vpt]=visualize_vec(data,u,v);
psfuvmap=visualize_vec(psf,u,v);

if (sum(sum(abs(psfuvmap)))==0)
    scale_fac=1;
else
    scale_fac=sum(sum(abs(psfuvmap)))/prod(size(psfuvmap));
end

scale_fac=(2*oversamp+1)^2/scale_fac;

map=fftshift(ifft2(ifftshift(pad_matrix(uvmap,oversamp))))*scale_fac;
psfmap=fftshift(ifft2(ifftshift(pad_matrix(psfuvmap,oversamp))))*scale_fac;


du=find_median_du(u);
dv=find_median_du(v);


nra=size(map,2);
ndec=size(map,1);
ra= (-(nra-1)/2:(nra-1)/2)*180/pi/du/nra;
dec= (-(ndec-1)/2:(ndec-1)/2)*180/pi/dv/ndec;


ra=ra/cos(dec_cent*pi/180)+ra_cent*15;
%ra=ra+ra_cent*15;
dec=dec+dec_cent;