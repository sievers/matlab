function[value]=write_C_data(filename,data,u,v,z)
fid=fopen(filename,'w');
if (fid==-1)
    error(['Unable to open data file ' filename ' in write_C_data']);
end

n=fread(fid,1,'int32');
n=length(data);
fwrite(fid,n,'int32');
fwrite(fid,data,'double');
fwrite(fid,u,'float');
fwrite(fid,v,'float');
fwrite(fid,z,'double');
fclose(fid);
