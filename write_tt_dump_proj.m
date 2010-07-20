function[proj]=write_tt_dump_proj(fileroot,mat,which_proj)
filename=[fileroot '_Proj_' num2str(which_proj) '.dmp'];
fid=fopen(filename,'w');

n=size(mat,2);

nbytes_out=4;
fwrite(fid,nbytes_out,'int');
fwrite(fid,n,'int');
fwrite(fid,nbytes_out,'int');

nbytes_out=8*prod(size(mat));
fwrite(fid,nbytes_out,'int');
fwrite(fid,mat,'double');
fwrite(fid,nbytes_out,'int');
fclose(fid);
