function[]=write_tt_dump_rgrid(fileroot,rgrid,du,nbeam)
n=(size(rgrid,2)*2)/size(rgrid,1);
if abs(n-round(n))~=0
    error(['Error - sizes of rgrid do not match up' num2str(size(rgrid))]);
end



filename=[fileroot '_Rvec.dmp'];
fid=fopen(filename,'w');

nbytes_in=4*2+8;
fwrite(fid,nbytes_in,'int');
fwrite(fid,nbeam,'int');
fwrite(fid,n,'int');
fwrite(fid,du,'double');
fwrite(fid,nbytes_in,'int');

nbytes_in=8*prod(size(rgrid));
fwrite(fid,nbytes_in,'int');
fwrite(fid,rgrid,'double');
fwrite(fid,nbytes_in,'int');
fclose(fid);


