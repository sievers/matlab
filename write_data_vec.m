function[value]=write_data_vec(filename,data,u,v,z)
fid=fopen(filename,'w');
if (fid==-1)
  error(['unable to open ' filename ' for writing.']);
end
n=length(data);
fwrite(fid,n,'int');
fwrite(fid,data,'double');
fwrite(fid,u,'float');
fwrite(fid,v,'float');
fwrite(fid,z,'double');
fclose(fid);



