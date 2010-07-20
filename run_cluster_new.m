function[data,udump,vdump,zdump,rgrid,noise_dump,cmb,noise_inv_filt,du,maxu,vn,en]=run_cluster_new(crebase,dump_tag,sig_tag,cmb_scale_fac,thresh)


if (~exist('cmb_scale_fac'))|(isempty(cmb_scale_fac))
    cmb_scale_fac=1; %assume the cmb is as advertised
end

if (~exist('thresh'))|(isempty(thresh)) %set the eigenvalue chop level
    thresh=3e-4;
end
disp(thresh)
[data,u,v,z,nl,np]=read_split_data([crebase '_SVEC']);
cmb=read_split_signal([crebase sig_tag '_TT']);

%disp(dumpbase);
[data_dump,udump,vdump,zdump,noise_dump,rgrid,du,nbeam,ndump]=read_tt_dump([crebase dump_tag],1);






zuse=zdump>0;
big_zuse=reshape([zuse zuse]',[2*length(zdump) 1]);
vec=(1:length(zuse))';
vec2=(1:length(big_zuse))';
keep=vec(zuse);
keep2=vec2(big_zuse);
data_dump=data_dump(keep2);
udump=udump(keep);
vdump=vdump(keep);
zdump=zdump(keep);
rgrid=rgrid(:,:,keep);
%noise_dump=noise_dump(keep2,keep2);
noise_dump=read_split_noise([crebase '_NOIS']);
ndump=length(zdump);
bigz=reshape([zdump zdump]',[2*length(zdump) 1]);
r=sqrt(u.^2+v.^2);
r2=reshape([r r]',[2*length(r) 1]);
maxu=max([max(abs(udump)) max(abs(vdump))]);


%now make sure that the noise diagonal is positive
vec=diag(noise_dump);
keep1=vec>0;
keep2=vec(2:2:end)>0;
data=data(keep1);
udump=udump(keep2);
vdump=vdump(keep2);
zdump=zdump(keep2);
rgrid=rgrid(:,:,keep2);
noise_dump=noise_dump(keep1,keep1);




noisevec=sqrt(diag(noise_dump));

if (thresh>=0) %send in a negative eigenvalue thresh to turn off filtering

    [vn,en]=eig(noise_dump+cmb_scale_fac*cmb);
    en=diag(en);
    crud=1./en;

    crud(en<thresh*max(en))=0;
    nkept=sum(crud>0)

    noise_inv_filt=vn*diag(crud)*vn';
    noise_inv_filt=0.5*(noise_inv_filt+noise_inv_filt');
else
    en=0;
    vn=0;
    %noise_inv_filt=0;
    noise_inv_filt=inv(noise_dump);
end





