function[rgrid,du,nbeam]=read_tt_dump_rgrid(fileroot,unpack_rgrid,do_pol)

if (~exist('do_pol'))
    do_pol=false;
end

if (do_pol)
    filename=[fileroot '_Rpol.dmp'];
else
    filename=[fileroot '_Rvec.dmp'];
end
fid=fopen(filename,'r');
nbytes_in=fread(fid,1,'int');
nbeam=fread(fid,1,'int');
n=fread(fid,1,'int');
du=fread(fid,1,'double');
nbytes_in=fread(fid,1,'int');

if (nargin<2)
    unpack_rgrid=0;
end
%unpack_rgrid

if (unpack_rgrid)
    
    rgrid(nbeam,nbeam,n)=0;
    nbytes_in=fread(fid,1,'int');

    for j=1:n,
        rgrid_in=fread(fid,[2*nbeam nbeam],'double');
        rgrid_use=rgrid_in(1:2:2*nbeam-1,:);
        rgrid_use=rgrid_use+i*rgrid_in(2:2:2*nbeam,:);
        rgrid(:,:,j)=rgrid_use;
    end
    nbytes_in=fread(fid,1,'int');
else
    nbytes_in=fread(fid,1,'int');
    rgrid=fread(fid,[2*nbeam nbeam*n],'double');
    nbytes_in=fread(fid,1,'int');
end
fclose(fid);

