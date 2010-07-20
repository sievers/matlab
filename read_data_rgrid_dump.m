function[svec,uvec,vvec,zvec,rgrid,du,nbeam,n]=read_data_rgrid_dump(fileroot)
filename=[fileroot '_Spol.dmp'];
fid=fopen(filename,'r');

nbytes_in=fread(fid,1,'int');
n=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
svec=fread(fid,2*n,'double');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
uvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
vvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
zvec=fread(fid,n,'double');
nbytes_in=fread(fid,1,'int');
fclose(fid);

filename=[fileroot '_Rpol.dmp'];
fid=fopen(filename,'r');
nbytes_in=fread(fid,1,'int');
nbeam=fread(fid,1,'int');
n_in=fread(fid,1,'int');
du=fread(fid,1,'double');
nbytes_in=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');
rgrid(nbeam,nbeam,n)=0;
for j=1:n,
    if (rem(j,100)==0)
        disp(j);
    end
    rgrid_in=fread(fid,[2*nbeam nbeam],'double');
    rgrid_use=rgrid_in(1:2:2*nbeam-1,:);
    rgrid_use=rgrid_use+i*rgrid_in(2:2:2*nbeam,:);
    rgrid(:,:,j)=rgrid_use;
end
nbytes_in=fread(fid,1,'int');
fclose(fid);
%now create R matrix.  For now, we'll assume that the fine and coarse grids
%are the same.  Otherwise complications ensue.

if (0)
    minu=min(min(uvec));
    maxu=max(max(uvec));
    minv=min(min(vvec));
    maxv=max(max(vvec));
    pad=(nbeam-1)/2;
    nu=maxu-minu+1;
    nv=maxv-minv+1;
    [nu nv pad minu minv]
    nfine=(nu+2*pad)*(nv+2*pad)
    rmat(nfine,n)=0;
    %vec(1:nfine,1)=0;
    u_off=uvec-minu+pad;
    v_off=vvec-minv+pad;
    nu=nu+2*pad;
    nv=nv+2*pad;


    for j=1:size(rgrid,3),
        center_coord=nv*u_off(j)+v_off(j);
        disp([j center_coord u_off(j) v_off(j)]);
        vec=zeros(nfine,1);
        for k=1:nbeam,
            vec(center_coord+(k-pad-1)*nv+(-pad:pad))=rgrid(:,k,j);
        end
        disp([max(size(vec)) nfine center_coord+(k-pad-1)*(nv)+pad])
        rmat(:,j)=vec;
    end
end

