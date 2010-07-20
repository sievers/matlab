function[mat]=read_split_src(filename,whichpol)

if (nargin<2)
    whichpol=0;
end


%fid=fopen(filename,'r','ieee-le');
fid=gzopen(filename);
%check for error
if (fid==-1)
    error(sprintf('Unable to open source file from %s',filename));
end
nbytes_in=fread(fid,1,'int32');
n=fread(fid,1,'int32');
nl=fread(fid,1,'int32');
np=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');

if (whichpol==1)
    n=n/3;
end


nbytes_in=fread(fid,1,'int32');
nmat=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');
disp(sprintf('Expecting %d matrices in file %s\n',nmat,filename));

mat(n,n,nmat)=0;
nx=n/2;
for j=1:nx,
    nbytes_in=fread(fid,1,'int32');
    jpt=fread(fid,1,'int32');
    nbytes_in=fread(fid,1,'int32');

    if (jpt~=j)
        error('Error - mismatch between expected and read rows in noise read.  Expected %d, had %d\n',j,jpt);
    end
    nr=2*j-1;
    ni=2*j;
    for k=1:nmat,
        nbytes_in=fread(fid,1,'int32');
        mat(1:nr,nr,k)=flipud(fread(fid,nr,'double'));
        mat(nr,1:nr,k)=mat(1:nr,nr,k)';
        nbytes_in=fread(fid,1,'int32');

        nbytes_in=fread(fid,1,'int32');
        mat(1:ni,ni,k)=flipud(fread(fid,ni,'double'));
        mat(ni,1:ni,k)=mat(1:ni,ni,k)';
        nbytes_in=fread(fid,1,'int32');
    end
end
fclose(fid);

