function[value]=write_mpilikely_mat(mat,filename,lmin,lmax)
if (nargin<4)
    lmax=5000;
end
if (nargin<3)
    lmin=0;
end
n=max(size(mat));

fid=fopen(filename,'w');
if (fid==-1)
    value=1;
    disp(sprintf('Error opening %s for writing.',filename));
    return;
end
value=0;
fwrite(fid,n,'int');
fwrite(fid,[lmin lmax],'float');
for j=1:n,
    fwrite(fid,mat(1:j,j),'double');
end
fclose(fid);
