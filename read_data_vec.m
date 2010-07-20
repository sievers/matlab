function[data,u,v,z]=read_data_vec(filename)
fid=fopen(filename,'r');
n=fread(fid,1,'int');
data=fread(fid,[n 1],'double');
u=fread(fid,[n/2 1],'float');
v=fread(fid,[n/2 1],'float');
z=fread(fid,[n/2 1],'double');
fclose(fid);