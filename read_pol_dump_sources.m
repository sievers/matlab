function[src1,nsrc,nest,dist]=read_pol_dump_sources(fileroot,which_source)
if (which_source>0)
    filename=[fileroot '_Dsrc_' num2str(which_source) '.dmp'];
    polname=[fileroot '_Dpol_' num2str(which_source) '.dmp'];
else
    filename=[fileroot '_Fsrc.dmp'];
    filename=[fileroot '_Fpol.dmp'];
end

[vecs1]=read_srcdump_file(filename);
[vecs2,dist]=read_srcdump_file(polname);
src1=[vecs1;vecs2];


nsrc=dist;
return


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

function[vecs,dist]=read_srcdump_file(fname)
fid=fopen(fname,'r');
assert(fid~=-1);
nb=fread(fid,1,'int');
assert(nb==8);
sz=fread(fid,2,'int');
nb=fread(fid,1,'int');
nb=fread(fid,1,'int');
nest=sz(1);
nsrc=sz(2);
assert(nb==8*2*nest*nsrc);
vecs=fread(fid,[2*nest nsrc],'double');
nb=fread(fid,1,'int');
assert(nb==8*2*nest*nsrc);
nb=fread(fid,1,'int');
assert(nb==4*nsrc);
dist=fread(fid,nsrc,'float');
nb=fread(fid,1,'int');
assert(nb==4*nsrc);



return


