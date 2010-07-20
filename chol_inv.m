function[r,p,d]=chol_inv(mat,opts)
if (nargin<2)
    opts.blocksize=250;
end
[r,p]=chol(mat);
if (p~=0)
    d=0;
    return;
end
d=diag(r);
r=tri_inv(r,'u',opts);
r=matprod_tri(r,r','u','l',opts);