function[nfiles]=how_many_files(fileroot,filetail,startval)

if (nargin<3)
    startval=1;
end

nfiles=0;
ok=1;
j=startval;
while (ok==1)
    filename=[fileroot num2str(j) filetail];
    fid=fopen(filename,'r');
    if (fid==-1)
        ok=0;
    else
        %disp(['found file ' filename]);
        j=j+1;
        nfiles=nfiles+1;
        fclose(fid);
    end
end
