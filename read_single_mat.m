function[mat]=read_single_mat(filename,pol)
if (nargin<2)
    pol=0;
end
%fid=fopen(filename,'r');
fid=gzopen(filename);
if (fid==-1)
    warning(['Unable to open file ' filename ' for reading.']);
    return;
end
n=fread(fid,1,'int');
lims=fread(fid,2,'float');
disp(['lims are ' num2str(lims')]);

if (pol>0)
    if rem(n,3)
        error('Polarization specified, but matrix doesn''t have multiple of 3 estimators.');
    end
end
if pol==1
    n=n/3;
end
if (pol==0)|(pol==1)
    mat(n,n)=0;
    for j=1:n,
        mat(1:j,j)=fread(fid,[j 1],'double');
    end

    fread(fid,2,'float');

    fclose(fid);
else
    npol=2*n/3;
    ntt=n/3;
    mat(npol,npol)=0;
    for j=1:ntt,
        crap=fread(fid,[j 1],'double');
    end
    for j=ntt+1:n,
        crap=fread(fid,[j 1],'double');
        jj=j-ntt;
        mat(1:jj,jj)=crap(ntt+1:j);
    end
    fclose(fid);
    n=npol;
end
%mat=mat+mat';
%for j=1:n,
%    mat(j,j)=mat(j,j)/2;
%end
for j=1:n,
    mat(j,1:j)=mat(1:j,j)';
end

