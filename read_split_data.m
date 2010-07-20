function[data,u,v,z,nl,np,ra,dec]=read_split_data(filename)

fid=fopen(filename,'r','ieee-le');
%check for error
if (fid==-1)
    error(sprintf('Unable to open SVEC file from %s',filename));
end
nbytes_in=fread(fid,1,'int32');
n=fread(fid,1,'int32');
nl=fread(fid,1,'int32');
np=fread(fid,1,'int32');
nbytes_in=fread(fid,1,'int32');

nbytes_in=fread(fid,1,'int32');
if (nbytes_in~=8*n)
    error(sprintf('Mismatch in requested bytes in SVEC read.  Expected %d, had %d\n',8*n,nbytes_in));
end
data=fread(fid,n,'double');
nbytes_in=fread(fid,1,'int32');
if (nargout>1)
    nbytes_in=fread(fid,1,'int32');
    if (nbytes_in~=4*n/2)
        error(sprintf('Mismatch in requested bytes while reading u.  Expected %d, had %d\n',2*n,nbytes_in));
    end
    u=fread(fid,n/2,'float');
    nbytes_in=fread(fid,1,'int32');

    nbytes_in=fread(fid,1,'int32');
    if (nbytes_in~=4*n/2)
        error(sprintf('Mismatch in requested bytes while reading v.  Expected %d, had %d\n',2*n,nbytes_in));
    end
    v=fread(fid,n/2,'float');
    nbytes_in=fread(fid,1,'int32');
  
    nbytes_in=fread(fid,1,'int32');
    if (nbytes_in~=8*n/2)
        error(sprintf('Mismatch in requested bytes while reading z.  Expected %d, had %d\n',4*n,nbytes_in));
    end
    z=fread(fid,n/2,'double');
    nbytes_in=fread(fid,1,'int32');    
end
nbytes_in=fread(fid,1,'int32');

%disp(['nbytes_in is ' num2str(nbytes_in)]);
pos=fread(fid,2,'double');
%disp(['nbytes in for ra/dec is ' num2str(nbytes_in) ' with pos ' num2str(pos')]);
if (length(pos)==2)
    nbytes_in=fread(fid,1,'int32');
    ra=pos(1)*180/pi/15;
    dec=pos(2)*180/pi;
else
    ra=nan;
    dec=nan;
end
  
%disp([ra dec])
fclose(fid);
