function[finemap_norm,rconv_sum,mat_var,cmb_sig,uuu]=normalize_finemap_flat(rgrid,u_dump,v_dump,du,z_dump,finemap,rconv)

shape=ones(5000,1);
cmb_sig=make_shape_tt_signal_mat_fast(rgrid,u_dump,v_dump,du,z_dump,shape,1,5000,'',1);
uuu=(1:size(cmb_sig,1));
uuu=(uuu-mean(uuu))*2*pi*du;

cent=ceil(length(uuu)/2);
n=length(uuu);


uuu_use=uuu(cent+2:n);
to_interp_vals=cmb_sig(:,cent);
to_interp_vals=to_interp_vals(cent+2:n);
params=polyfit(log(uuu_use),log(to_interp_vals'),1);
finemap_u=du*(1:size(finemap,1))*2*pi;
finemap_u=finemap_u-mean(finemap_u);

finemap_v=du*(1:size(finemap,2))*2*pi;
finemap_v=finemap_v-mean(finemap_v);

finemap_r=repmat(finemap_u'.^2,[1 length(finemap_v)])+repmat(finemap_v.^2,[length(finemap_u) 1]);
finemap_norm=sqrt(exp(polyval(params,log(finemap_r))));
finemap_norm(finemap_r==0)=1;

imagesc(finemap_u,finemap_v,abs(finemap)./sqrt(finemap_norm)/sqrt(10)*2.725e6);colorbar
zero_mat=(abs(finemap)>0);
mat_var=0;
nmat=1000;
rconv_sum=rconv/sum(sum(rconv));
for j=1:nmat, 
    if ((j/100)==round(j/100)), 
        disp(num2str(j));
    end;
    mat=(randn(size(zero_mat))+i*randn(size(zero_mat))).*zero_mat;
    mat=conv2(mat,rconv_sum,'same');
    mat_var=mat_var+abs(mat).^2;
end;
mat_var=sqrt(mat_var/nmat);
rconv_sum=rconv_sum/max(max(abs(mat_var)));
%normalize_finemap_stuff mat_var rconv_sum zero_mat finemap_norm
