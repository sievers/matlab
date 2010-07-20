function[value]=filter_2noises(base1,base2,outbase,thresh,noise_facs)

if (length(thresh)>2)
    error('too many threshold values in filter_2noises.');
end
if (length(thresh)==1)
    warning('only sent in one threshold in filter_2noises.  Assuming same for both.  If incorrect, you may want to exit ASAP.');
    thresh(2)=thresh(1);
end

if (~exist('noise_facs'))
    noise_facs=[1 1];
end
if (length(noise_facs)==1)
    warning('Only one noise factor sent in.  Assuming it is the same for both.  If not, abort ASAP.');
    noise_facs(2)=noise_facs(1);
end
if (length(noise_facs)~=2)
    error('length of noise_facs incorrect in filter_2noises.');
end

    

[data1,u1,v1,z1]=read_tt_dump_svec(base1);
[data2,u2,v2,z2]=read_tt_dump_svec(base2);
zz1=reshape([z1 z1]',[2*length(z1) 1]);
zz2=reshape([z2 z2]',[2*length(z2) 1]);

keep_ind1=(zz1>0);
keep_ind2=(zz2>0);



noise1=read_tt_dump_noise(base1,1);
if ~(min(z1)>0)
    noise1=noise1(keep_ind1,keep_ind1);
end
if (thresh(1)>0)
    [v1,ee]=eig(noise1);
    ee=diag(ee);
    disp(['Eigenvalue range is ' num2str([min(ee) max(ee)])]);
    cut=cut_thresh*max(ee);
    nclean=sum(ee<cut);
    cut_vec=e1<(thresh(1)*max(e1));
    
    
