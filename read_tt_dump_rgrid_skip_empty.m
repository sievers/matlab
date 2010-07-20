function[rgrid,du,nbeam,zvec]=read_tt_dump_rgrid_skip_empty(fileroot,zcut)
if (~exist('zcut'))
    zcut=0;
end
[svec,uvec,vvec,zvec,psf]=read_tt_dump_svec(fileroot);

filename=[fileroot '_Rvec.dmp'];
fid=fopen(filename,'r');
nbytes_in=fread(fid,1,'int');
nbeam=fread(fid,1,'int');
n=fread(fid,1,'int');
du=fread(fid,1,'double');
nbytes_in=fread(fid,1,'int');


nkeep=sum(zvec>zcut);
rgrid(nbeam,nbeam,nkeep)=0;
ii=0;

nbytes_in=fread(fid,1,'int');
for j=1:n,
    rgrid_in=fread(fid,[2*nbeam nbeam],'double');
    if (zvec(j)>zcut)
        ii=ii+1;
        rgrid_use=rgrid_in(1:2:2*nbeam-1,:);
        rgrid_use=rgrid_use+i*rgrid_in(2:2:2*nbeam,:);
        rgrid(:,:,ii)=rgrid_use;
    end
end
zvec=zvec(zvec>zcut);