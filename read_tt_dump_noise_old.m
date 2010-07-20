function[big_noise]=read_tt_dump(fileroot,convert_to_mat)

if (nargin<2)
    convert_to_mat=0;
end


filename=[fileroot '_Nvec.dmp'];
fid=fopen(filename,'r');

nbytes_in=fread(fid,1,'int');
n=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
big_nmat=fread(fid,[2*n n],'double');
nbytes_in=fread(fid,1,'int');

if (convert_to_mat)
    [s,u,v,zvec]=read_tt_dump_svec(fileroot);
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

    zvec(zvec==0)=1;
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
else
    big_noise=big_nmat;
end


fclose(fid);
