function[noise]=read_split_noise(filename,whichpol)

if (nargin<2)
    whichpol=0;
end

fid=fopen(filename,'r','ieee-le');
%check for error
if (fid==-1)
    error(sprintf('Unable to open noise file from %s',filename));
end
nbytes_in=fread(fid,1,'int32');
n=fread(fid,1,'int32');
nl=fread(fid,1,'int32');
np=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');

disp([n nl np])
if (whichpol==1)
    n=n/3;
end

noise(n,n)=0;
nx=n/2;
do_print=0;
for j=1:nx,   
    nbytes_in=fread(fid,1,'int32');
    jpt=fread(fid,1,'int32');
    nbytes_in=fread(fid,1,'int32');
    %if (jpt>183)
    %    do_print=1;
    %    disp(num2str(jpt))
    %end

    if (jpt~=j)
        error('Error - mismatch between expected and read rows in noise read.  Expected %d, had %d\n',j,jpt);
    end
    nr=2*j-1;
    ni=2*j;
    nbytes_in=fread(fid,1,'int32');
    if (do_print)
        disp([jpt nbytes_in/8]);
    end
    
    noise(1:nr,nr)=flipud(fread(fid,nr,'double'));
    noise(nr,1:nr)=noise(1:nr,nr)';
    nbytes_in=fread(fid,1,'int32');
        
    nbytes_in=fread(fid,1,'int32');
    noise(1:ni,ni)=flipud(fread(fid,ni,'double'));
    noise(ni,1:ni)=noise(1:ni,ni)';
    nbytes_in=fread(fid,1,'int32');

end
fclose(fid);

