function[have_file]=file_exists(fname)
fid=fopen(fname,'r');
if (fid==-1)
    have_file=false;
    return;
else
    fclose(fid);
    have_file=true;
end
