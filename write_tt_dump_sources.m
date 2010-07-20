function[]=write_tt_dump_sources(fileroot,src1,which_source,dist)
if (which_source>0)
    filename=[fileroot '_Dsrc_' num2str(which_source) '.dmp'];
else
    filename=[fileroot '_Fsrc.dmp'];
end
if (nargin<4)
    dist=zeros(size(src1,2),1);
end
%which_source
%filename=([fileroot '_Dsrc_' num2str(which_source) '.dmp'])

fid=fopen(filename,'w');
if (fid==-1)
    error(['Unable to write to source file ' filename]);
else
    nbytes_out=8;
    fwrite(fid,nbytes_out,'int');
    fwrite(fid,size(src1,1)/2,'int');
    fwrite(fid,size(src1,2),'int');
    fwrite(fid,nbytes_out,'int');

    nbytes_out=8*prod(size(src1));
    fwrite(fid,nbytes_out,'int');
    fwrite(fid,src1,'double');
    fwrite(fid,nbytes_out,'int');
    nsrc=size(src1,2);
    nb=4*nsrc;
    if length(dist)~=nsrc
        warning(['Warning - distance length mismatch in write_tt_dump_sources - ' num2str([length(dist) nsrc size(src1)])]);
        if (length(dist)>nsrc)
            dist=dist(1:nsrc);
        else
            dist(nsrc)=0;
        end
    end
    fwrite(fid,nb,'int');
    fwrite(fid,dist,'float');
    fwrite(fid,nb,'int');
    fclose(fid);
end
