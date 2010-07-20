function[svec,uvec,vvec,zvec,psf]=read_tt_dump_svec(fileroot)
filename=[fileroot '_Svec.dmp'];
fid=fopen(filename,'r');
if (fid==-1)
    filename=fileroot;
    fid=fopen(filename,'r');
    if (fid==-1)
        error(['Unable to find svec associated with dump ' fileroot]);
    end
end


nbytes_in=fread(fid,1,'int');
n=fread(fid,1,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
svec=fread(fid,2*n,'double');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
uvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
vvec=fread(fid,n,'int');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
zvec=fread(fid,n,'double');
nbytes_in=fread(fid,1,'int');

nbytes_in=fread(fid,1,'int');
psf=fread(fid,nbytes_in/8,'double');
nbytes_in2=fread(fid,1,'int');



fclose(fid);
