function[src1,nsrc,nest,dist]=read_tt_dump_sources(fileroot,which_source)
if (which_source>0)
    filename=[fileroot '_Dsrc_' num2str(which_source) '.dmp'];
else
    filename=[fileroot '_Fsrc.dmp'];
end

fid=fopen(filename,'r');
if (fid==-1)
    disp(['do not have source file ' filename]);
    nsrc=0;    
    src1=0;
    nest=0;
    dist=0;
    return;
else
    nbytes_in=fread(fid,1,'int');
    nest=fread(fid,1,'int');
    nsrc=fread(fid,1,'int');
    nbytes_in=fread(fid,1,'int');
    
    disp(['sizes of ' filename ' are ' num2str([nest nsrc])]);
    nbytes_in=fread(fid,1,'int');
    src1=fread(fid,[2*nest nsrc],'double');
    nbytes_in=fread(fid,1,'int');

    disp([nest nsrc nbytes_in]);
    if (nargout>3)
      nb=fread(fid,1,'int');
      [nb nsrc]
      if (nb~=4*nsrc)
        warning('source distances not present, but asked for');
        dist='';
        fclose(fid);
        return;
      end
      dist=fread(fid,[nsrc 1],'float');
      nb2=fread(fid,1,'int');
      if (nb~=nb2)
        warning('Size mismatch reading source distances.');
      end
    end
    fclose(fid);      
end

