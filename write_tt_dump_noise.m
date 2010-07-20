function[value]=write_tt_dump(fileroot,mat)



filename=[fileroot '_Nvec.dmp'];
fid=fopen(filename,'w');

n=max(size(mat))/2;

nbytes_in=4;


fwrite(fid,nbytes_in,'int');
fwrite(fid,n,'int');
fwrite(fid,nbytes_in,'int');

nbytes_in=8*2*n*n;
fwrite(fid,nbytes_in,'int');
fwrite(fid,mat,'double');
fwrite(fid,nbytes_in,'int');
fclose(fid);
