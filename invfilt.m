function[noise_inv_filt]=invfilt(noise,thresh)
if (thresh>=0) %send in a negative eigenvalue thresh to turn off filtering

    [vn,en]=eig(noise);
    en=diag(en);
    crud=1./en;

    crud(en<thresh*max(en))=0;
    nkept=sum(crud>0)

    noise_inv_filt=vn*diag(crud)*vn';
    noise_inv_filt=0.5*(noise_inv_filt+noise_inv_filt');
else
    en=0;
    vn=0;
    noise_inv_filt=0;
end
