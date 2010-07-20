function[data,noise,sig]=makeup_set_to_fit(n,namebase,corrlens)
x=(1:n)';
xmat=repmat(x,1,n);
dxsq=-0.5*(xmat-xmat').^2;
if (nargin<3)
    corrlens=[2 4 6];
end

noise=eye(n);
nband=max(size(corrlens));
for j=nband:-1:1,
    sig(:,:,j)=exp(dxsq/(corrlens(j)^2));
end
%whos
source=zeros(n);


name=sprintf('%s.noise',namebase);
write_mpilikely_mat(noise,name);
system(sprintf('gzip -f %s',name));

name=sprintf('%s.source_0',namebase);
write_mpilikely_mat(source,name);
system(sprintf('gzip -f %s',name));

name=sprintf('%s.proj_0',namebase);
write_mpilikely_mat(source,name);
system(sprintf('gzip -f %s',name));

for j=1:max(size(corrlens)),
    name=sprintf('%s.pol_TT_%d',namebase,j-1);
    write_mpilikely_mat(sig(:,:,j),name);
    system(sprintf('gzip -f %s',name));
end

cov=noise;
for j=1:max(size(corrlens)),
    cov=cov+sig(:,:,j);
end
[v,e]=eig(cov);
crud=randn(n,1).*sqrt(diag(e));
data=v*crud;
name=sprintf('%s.data',namebase);
write_mpilikely_data(data,name);
system(sprintf('gzip -f %s',name));

    