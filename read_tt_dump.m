function[svec,uvec,vvec,zvec,big_noise,rgrid,du,nbeam,n,src1,src2,src3]=read_tt_dump(fileroot,skipnoise)
filename=[fileroot '_Svec.dmp'];
fid=fopen(filename,'r');

nbytes_in=fread(fid,1,'int');
n=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
svec=fread(fid,2*n,'double');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
uvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
vvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
zvec=fread(fid,n,'double');
nbytes_in=fread(fid,1,'int');
fclose(fid);

filename=[fileroot '_Nvec.dmp'];
fid=fopen(filename,'r');

nbytes_in=fread(fid,1,'int');
n_in=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');
if (n_in~=n)
    error(sprintf('error - n_in and n do not match, %d vs. %d',n_in,n));
end
nbytes_in=fread(fid,1,'int');
big_nmat=fread(fid,[2*n n],'double');
nbytes_in=fread(fid,1,'int');

donoise=1;
if (exist('skipnoise'))
    if (skipnoise>0)
        donoise=0;
    end
end
if (donoise)
    disp('reading noise');
    noise_real=0;
    noise_im=0;
    noise_real=big_nmat(1:2:(2*n-1),:);
    noise_im=big_nmat(2:2:2*n,:);
    big_nmat=noise_real+i*noise_im;
    noise_mat=tril(big_nmat);
    noise_mat=noise_mat+noise_mat';
    noise_mat=noise_mat-0.5*diag(diag(noise_mat));

    noise_bar=triu(big_nmat);
    noise_bar=noise_bar+noise_bar';
    noise_bar=noise_bar-diag(diag(noise_bar));
    clear big_nmat;

    z_mat=1./(zvec*zvec');
    noise_bar=noise_bar.*z_mat;
    noise_mat=noise_mat.*z_mat;

    n_rr=0.5*real(noise_mat+noise_bar);
    n_ii=0.5*real(noise_mat-noise_bar);
    n_ri=0.5*imag(noise_bar-noise_mat);
    n_ir=0.5*imag(noise_bar+noise_mat);
    big_noise(2*n,2*n)=0;

    big_noise(1:2:2*n-1,1:2:2*n-1)=n_rr;
    big_noise(2:2:2*n,2:2:2*n)=n_ii;
    big_noise(1:2:2*n-1,2:2:2*n)=n_ri;
    big_noise(2:2:2*n,1:2:2*n-1)=n_ir;
    big_noise=triu(big_noise);
    big_noise=big_noise+big_noise';
    big_noise=big_noise-0.5*diag(diag(big_noise));
    fclose(fid);
else
    disp('skipping noise read');
    big_noise=0;
end


filename=[fileroot '_Rvec.dmp'];
fid=fopen(filename,'r');
nbytes_in=fread(fid,1,'int');
nbeam=fread(fid,1,'int');
n_in=fread(fid,1,'int');
du=fread(fid,1,'double');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
nbytes_in_targ=2*nbeam*nbeam*n*8;
%disp(['nybtes in, target are: ' num2str([nbytes_in nbytes_in_targ])]);
rgrid(nbeam,nbeam,n)=0;

for j=1:n,
    rgrid_in=fread(fid,[2*nbeam nbeam],'double');
    rgrid_use=rgrid_in(1:2:2*nbeam-1,:);
    rgrid_use=rgrid_use+i*rgrid_in(2:2:2*nbeam,:);
    rgrid(:,:,j)=rgrid_use;
end
nbytes_in=fread(fid,1,'int');
fclose(fid);
%now create R matrix.  For now, we'll assume that the fine and coarse grids
%are the same.  Otherwise complications ensue.

if (0)
    minu=min(min(uvec));
    maxu=max(max(uvec));
    minv=min(min(vvec));
    maxv=max(max(vvec));
    pad=(nbeam-1)/2;
    nu=maxu-minu+1;
    nv=maxv-minv+1;
    [nu nv pad minu minv]
    nfine=(nu+2*pad)*(nv+2*pad)
    rmat(nfine,n)=0;
    %vec(1:nfine,1)=0;
    u_off=uvec-minu+pad;
    v_off=vvec-minv+pad;
    nu=nu+2*pad;
    nv=nv+2*pad;


    for j=1:size(rgrid,3),
        center_coord=nv*u_off(j)+v_off(j);
        disp([j center_coord u_off(j) v_off(j)]);
        vec=zeros(nfine,1);
        for k=1:nbeam,
            vec(center_coord+(k-pad-1)*nv+(-pad:pad))=rgrid(:,k,j);
        end
        disp([max(size(vec)) nfine center_coord+(k-pad-1)*(nv)+pad])
        rmat(:,j)=vec;
    end
end

if (nargout>9)
    
    filename=[fileroot '_Dsrc_1.dmp'];
    fid=fopen(filename,'r');
    if (fid~= -1)
        nbytes_in=fread(fid,1,'int');
        nest=fread(fid,1,'int');
        nsrc=fread(fid,1,'int');
        nbytes_in=fread(fid,1,'int');
        nbytes_in=fread(fid,1,'int');
        src1=fread(fid,[2*nest nsrc],'double');
        fclose(fid);
        if  (nargout>10)
            filename=[fileroot '_Dsrc_2.dmp'];
            fid=fopen(filename,'r');
            if (fid~= -1)
                nbytes_in=fread(fid,1,'int');
                nest=fread(fid,1,'int');
                nsrc=fread(fid,1,'int');
                nbytes_in=fread(fid,1,'int');
                nbytes_in=fread(fid,1,'int');
                src2=fread(fid,[2*nest nsrc],'double');
                fclose(fid);
            end
        end
        
        if  (nargout>11)
            filename=[fileroot '_Dsrc_3.dmp'];
            fid=fopen(filename,'r');
            if (fid~= -1)
                nbytes_in=fread(fid,1,'int');
                nest=fread(fid,1,'int');
                nsrc=fread(fid,1,'int');
                nbytes_in=fread(fid,1,'int');
                nbytes_in=fread(fid,1,'int');
                src3=fread(fid,[2*nest nsrc],'double');
                fclose(fid);
            end
        end
    end
end


