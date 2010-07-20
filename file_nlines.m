function[nline]=file_nlines(fname)
fid=fopen(fname,'r');
if (fid==-1)
    value=-1;
    return
end

nline=0;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    nline=nline+1;
end
fclose(fid);
