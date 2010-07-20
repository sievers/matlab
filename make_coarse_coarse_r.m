function[mat]=make_coarse_coarse_r(rdump,u,v,pad)
n=max(size(u));
mat(n,n)=0;
for j=1:n,
    mat(:,j)=get_src_vec_from_r(1,rdump,u(j),v(j),u,v,pad);
end
