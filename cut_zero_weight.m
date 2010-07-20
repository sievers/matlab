function[svec,udump,vdump,zdump,noise_dump,rgrid,du,nbeam,n,src1,src2]=cut_zero_weight(svec,udump,vdump,zdump,noise_dump,rgrid,du,nbeam,n,src1,src2)
ind=(1:n)';
keep=ind(zdump>0);
big_keep=sort([2*keep'-1 2*keep']');
svec=svec(big_keep);
udump=udump(keep);
vdump=vdump(keep);
zdump=zdump(keep);
noise_dump=noise_dump(big_keep,big_keep);
rgrid=rgrid(:,:,keep);
n=length(keep);
if (nargin>9)
    src1=src1(big_keep,:);
end
if (nargin>10)
    src2=src2(big_keep,:);
end

