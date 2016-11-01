function[mminv]=invscale(mat)
%rescale by diagonal elements in case matrix is badly behaved just due to normalization

vec=1./sqrt(diag(mat));
mm=mat.*(vec*vec');
mminv=inv(mm);
mminv=mminv.*(vec*vec');

