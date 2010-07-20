function[proj]=read_tt_dump(fileroot,which_proj)
filename=[fileroot '_Proj_' num2str(which_proj) '.dmp'];
fid=fopen(filename,'r');
if (fid==-1)
    proj=0;
    disp(['unable to open projection matrix ' fileroot]);
else  
    nbytes_in=fread(fid,1,'int');
    n=fread(fid,1,'int');
    nbytes_in=fread(fid,1,'int');

    nbytes_in=fread(fid,1,'int');
    proj=fread(fid,[2*n n],'double');
    nbytes_in=fread(fid,1,'int');
    fclose(fid);
end
