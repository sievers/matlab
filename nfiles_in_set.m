function[nfiles]=nfiles_in_set(fileroot)
nfiles=1;
done=0;
while (done==0)
    fid=fopen([fileroot num2str(nfiles-1)],'r');
    if (fid==-1)
        done=1;
        nfiles=nfiles-1;
    else
        nfiles=nfiles+1;
        fclose(fid);
    end
end
