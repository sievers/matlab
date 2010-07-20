function[svec,uvec,vvec,zvec,big_noise,rgrid,du,nbeam,n,src1,src2]=read_tt_dump_halfsize(fileroot)
if (nargout>10)
    [svec,uvec,vvec,zvec,big_noise,rgrid,du,nbeam,n,src1,src2]=read_tt_dump(fileroot);
else
    if (nargout>9)
        [svec,uvec,vvec,zvec,big_noise,rgrid,du,nbeam,n,src1]=read_tt_dump(fileroot);
    else
        [svec,uvec,vvec,zvec,big_noise,rgrid,du,nbeam,n]=read_tt_dump(fileroot);
    end
end

    
keep_vec=(1:2:n)';
big_keep_vec=sort([2*keep_vec'-1 2*keep_vec']');


svec=svec(big_keep_vec);
uvec=uvec(keep_vec);
vvec=vvec(keep_vec);
zvec=zvec(keep_vec);
big_noise=big_noise(big_keep_vec,big_keep_vec);
rgrid=rgrid(:,:,keep_vec);
if (nargout>9)
    src1=src1(keep_vec,:);
end
if (nargout>10)
    src2=src2(keep_vec,:);
end
n=ceil( (n-0.001)/2);
