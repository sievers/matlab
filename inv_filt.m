function[noise_inv_filt,vn,en]=inv_filt(mat,thresh)


[vn,en]=eig(mat);
en=diag(en);
crud=1./en;

crud(en<thresh*max(en))=0;
nkept=sum(crud>0)

noise_inv_filt=vn*diag(crud)*vn';
noise_inv_filt=0.5*(noise_inv_filt+noise_inv_filt');
