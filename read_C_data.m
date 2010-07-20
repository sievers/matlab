function[data,u,v,z]=read_C_data(filename)
%fid=fopen(filename,'r');
fid=gzopen(filename);
if (fid==-1)
    error(['Unable to open data file ' filename]);
end
n=fread(fid,1,'int32');
data=fread(fid,n,'double');
u=fread(fid,n/2,'float');
v=fread(fid,n/2,'float');
z=fread(fid,n/2,'double');
fclose(fid);
