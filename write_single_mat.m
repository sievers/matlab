function[]=write_single_mat(filename,mat,llow,lhigh)
% Write a single (symmetric) matrix to disk in a format that mpilikely understands.
% Arg 1:  filename
% Arg 2:  matrix
% Arg 3:  llow
% Arg 4:  lhigh
n=max(size(mat));
if (nargin<3)
    lhigh=5000;
end
if (nargin<2)
    llow=0;
end

fid=fopen(filename,'w');
if (fid==-1)
    warning(['Unable to open file ' filename ' for writing.']);
    return;
end
fwrite(fid,n,'int');
fwrite(fid,[llow lhigh],'float');
for j=1:n,
    fwrite(fid,mat(1:j,j),'double');
end
fwrite(fid,[llow lhigh],'float');
fclose(fid);
