function[mat,ipol,bandmin,bandmax]=read_split_signal(filename)

%fid=fopen(filename,'r','ieee-le');
fid=gzopen(filename);
%check for error
if (fid==-1)
    error(sprintf('Unable to open signal file from %s',filename));
end
nbytes_in=fread(fid,1,'int32');
n=fread(fid,1,'int32');
nl=fread(fid,1,'int32');
np=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');

nbytes_in=fread(fid,1,'int32');
ipol=fread(fid,1,'int32');
nmat=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');
disp(sprintf('Expecting %d matrices for polarization %d in file %s\n',nmat,ipol,filename));

nbytes_in=fread(fid,1,'int32');
bandmin=fread(fid,nmat,'float');
nbytes_in=fread(fid,1,'int32');
%bandmin
nbytes_in=fread(fid,1,'int32');
bandmax=fread(fid,nmat,'float');
nbytes_in=fread(fid,1,'int32');
%bandmax


mat(n,n,nmat)=0;
nx=n/2;
for j=1:nx,
    for k=1:nmat,
        nbytes_in=fread(fid,1,'int32');
        jpt=fread(fid,1,'int32');
        nbytes_in=fread(fid,1,'int32');
        
        if (jpt~=j)
            error('Error - mismatch between expected and read rows in noise read.  Expected %d, had %d\n',j,jpt);
        end
        nr=2*j-1;
        ni=2*j;

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

