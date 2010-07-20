function[value]=write_tt_dump_svec(fileroot,s,u,v,z,psf)
n=length(s)/2;
filename=[fileroot '_Svec.dmp'];
fid=fopen(filename,'w');

nbytes_out=4;
fwrite(fid,nbytes_out,'int');
fwrite(fid,n,'int');
fwrite(fid,nbytes_out,'int');

nbytes_out=8*2*n;
fwrite(fid,nbytes_out,'int');
fwrite(fid,s,'double');
fwrite(fid,nbytes_out,'int');

nbytes_out=4*n;
fwrite(fid,nbytes_out,'int');
fwrite(fid,u,'int');
fwrite(fid,nbytes_out,'int');

nbytes_out=4*n;
fwrite(fid,nbytes_out,'int');
fwrite(fid,v,'int');
fwrite(fid,nbytes_out,'int');

nbytes_out=8*n;
fwrite(fid,nbytes_out,'int');
fwrite(fid,z,'double');
fwrite(fid,nbytes_out,'int');

if (nargin<6)
    psf=0*s;
end

nbytes_out=8*2*n;
fwrite(fid,nbytes_out,'int');
fwrite(fid,psf,'double');
fwrite(fid,nbytes_out,'int');


fclose(fid);
