function[lines]=read_lines(fname)
%if isstr(fname)
if ischar(fname)
    fid=fopen(fname,'r');
    if (fid==-1)
        error(['unable to read ' fname '.']);
    end
else
    fid=fname;
end
lines={};
while (1)
    line_in=fgets(fid);
    if (isstr(line_in))
        lines=[lines;{line_in}];
    else
        fclose(fid);
        return;
    end
end
