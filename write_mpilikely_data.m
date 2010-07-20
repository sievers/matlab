function[value]=write_mpilikely_data(data,filename,u,v,z)
n=max(size(data));
ncell=n/2;
if (nargin<5)
    z=ones(ncell,1);
end
if (nargin<4)
    v=0*z;
end
if (nargin<3)
    u=0*z;
end


value=0;
fid=fopen(filename,'w');
if (fid==-1)
    value=1;
    error(sprintf('Unable to open %s for writing.',filename));
    return;
end
fwrite(fid,n,'int');
fwrite(fid,data,'double');
fwrite(fid,u,'float');
fwrite(fid,v,'float');
fwrite(fid,z,'double');
fclose(fid);