function[vec]=read_vec(fname)
fid=fopen(fname,'r');
n=fread(fid,1,'int');
if (n<0)
    n=-1*n;
    vec=fread(fid,[n 1],'double');
else
    vec=fread(fid,[n 1],'float');
end

fclose(fid);