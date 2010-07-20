function[fid]=gzopen(filename)
if (exist('strtrim'))
  filename=strtrim(filename);
end
ln=length(filename);
if (strcmp(filename(ln-2:ln),'.gz'))
    filename2=filename(1:ln-3);

    %now check to see if we have both the gzipped and gunzipped versions of
    %the file.  If we do, and the gunzipped one is newer, then force the
    %unzipping.
    
    fid1=fopen(filename,'r');
    fid2=fopen(filename2,'r');
    
    if (fid1>0)&(fid2>0)
        if (isnewer(filename,filename2))
            disp(['File ' filename ' is newer than ' filename2 '.  Forcing gunzip.']);
            system(['gunzip -c ' filename ' > ' filename2]);
        end
    end    
    
    if (fid1~=-1)
        fclose(fid1);
    end
    if (fid2~=-1)
        fclose(fid2);
    end
    filename=filename2;
end



fid=fopen(filename,'r');
if (fid==-1)
    fid=fopen([filename '.gz'],'r');
    if (fid==-1)
        disp(['unable to find either ' filename ' or  ' filename '.gz in gzopen.']);
        return;
    else
        fclose(fid);
        system(['gunzip -c ' filename '.gz > ' filename]);
        fid=fopen(filename,'r');
        if (fid==-1)
            disp(['Oddness in gzopening ' filename '.  gzipped file found, but not unzipped successfully.']);
        end
    end
end
