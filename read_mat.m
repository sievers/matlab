function[mat,ells]=read_mat(filename,whichpol)
%Read in a single matrix.  Whichpol=0 for whole matrix, 1 for TT only, 2
%for Pol only

if (nargin<2)
    whichpol=0;
end
fid=fopen(filename,'r');
n_in=fread(fid,1,'int');
ells=fread(fid,2,'float');

n=n_in;
if (whichpol==1)
    n=n_in/3;
end
if (whichpol==2)
    n=n_in*2/3;
end



mat(n,n)=0;
if ((whichpol==0)||(whichpol==1))
    for j=1:n,
        mat(1:j,j)=fread(fid,[j 1],'double');
    end
end
if (whichpol==2)
    mat(n,n)=0;
    ntt=n/2;
    for j=1:ntt,
        crap=fread(fid,[j 1],'double');
    end
    for j=1:n,
        crap=fread(fid,[j+n/2],'double');
        mat(1:j,j)=crap((ntt+1):(ntt+j));
    end
end
fclose(fid);

%for j=1:n,
%    for k=1:j,
%        mat(j,k)=mat(k,j);
%    end
%end
mat=(mat+mat');
mat=mat-0.5*diag(diag(mat));

