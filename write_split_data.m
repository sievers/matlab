function[value]=write_split_data(filename,data,u,v,z,nl,np,ra,dec)

if (nargin<7)
    np=0;
end
if (nargin<6)
    nl=length(data);
end


fid=fopen(filename,'w','ieee-le');
%check for error
if (fid==-1)
    error(sprintf('Unable to open SVEC file from %s',filename));
end

n=length(data);

nbytes_in=3*4;
fwrite(fid,nbytes_in,'int32');
fwrite(fid,nl,'int32');
fwrite(fid,nl,'int32');
fwrite(fid,np,'int32');
fwrite(fid,nbytes_in,'int32');


fwrite(fid,8*n,'int32');
fwrite(fid,data,'double');
fwrite(fid,8*n,'int32');

nbytes_in=4*n/2;
fwrite(fid,nbytes_in,'int32');
fwrite(fid,u,'float');
fwrite(fid,nbytes_in,'int32');

fwrite(fid,nbytes_in,'int32');
fwrite(fid,v,'float');
fwrite(fid,nbytes_in,'int32');

nbytes_in=8*n/2;
nbytes_in=fwrite(fid,nbytes_in,'int32');
fwrite(fid,z,'double');
nbytes_in=fwrite(fid,nbytes_in,'int32');

if (exist('dec'))
  nbytes_in=8*2; 
  fwrite(fid,nbytes_in,'int32');
  fwrite(fid,ra*15*pi/180,'double');
  fwrite(fid,dec*pi/180,'double');
  fwrite(fid,nbytes_in,'int32');
end

fclose(fid);
