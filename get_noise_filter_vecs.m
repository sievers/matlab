function[noise_filt,vecs]=get_noise_filter_vecs(varargin)
noisename=varargin{1};
default_thresh=1e-7;
have_dump=0;
if length(varargin)==1
    dumpname=noisename;
    thresh=default_thresh;
end
if length(varargin)==2
    crap=varargin{2};
    if (isstr(crap))
        thresh=default_thresh;
        %dumpname=crap;
        have_dump=1;
    else
        thresh=varargin{2};
        %dumpname=noisename;
    end
end
if length(varargin)==3
    crap=varargin{2};
    if (isstr(crap))
        dumpname=varargin{2};
        thresh=varargin{3};
    else
        dumpname=varargin{3};
        thresh=varargin{2};
    end
end

if (~have_dump)
    dumpname=noisename;
end
dumpname=local_find_dump(dumpname)
if (dumpname)
    [svec,uvec,vvec,zvec]=read_tt_dump_svec(dumpname);
else
    if ((have_dump)||(nargout>1))
        return  %if you asked for a dump, but couldn't find one, probably time to be upset.
    end
end
noise=read_single_mat(noisename);
whos
[vv,ee]=eig(noise);
ee=diag(ee);
thresh
if (dumpname)
    
    ind=(ee<thresh*max(ee));
    vecs=vv(:,ind);
    z=reshape([zvec zvec]',[2*length(zvec) 1]);
    have_weight=z>0;
    z=z(have_weight);
    ii=1:(2*length(zvec));
    igood=ii(have_weight);
    ibad=ii(~have_weight);
    for j=1:size(vecs,2), 
        vecs(:,j)=vecs(:,j).*z;
    end
    clear blob;
    blob(igood,:)=vecs;
    blob(ibad,:)=0;
    vecs=blob;
    clear blob;
    
end
cutval=thresh*max(ee);
ee(ee<cutval)=cutval;
noise_filt=vv*diag(ee)*vv';
disp(['cutting ' num2str(sum(ind)) ' elements out of ' num2str(length(ee))]);









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[dumpnm]=local_find_dump(nm)

if (findstr('Svec.dmp',nm))
    fid=fopen(nm,'r');
    if (fid==-1)
        dumpnm='';
        warning(['Unable to find the requested dump file ' nm]);
        return;
    end
else
    str=[nm '_Svec.dmp'];
    fid=fopen(str,'r');
    if (fid>0)
        dumpnm=str;
        fclose(fid);
        return;
    end
end
%if we got here, the incoming string wasn't directly pointing to a
%dumpfile.  Look around a bit more

ind=findstr(nm,'.noise');
if (ind)
    ind=ind(length(ind)); %only to last one.  Might otherwise hit problems.
    nm_use=nm(1:ind-1)    
else
    nm_use=nm;
end

str=[nm_use '_Svec.dmp'];
fid=fopen(str,'r');
if (fid>0)
    dumpnm=str;
    fclose(fid);
    return;
end
str=[nm_use '_dump_Svec.dmp'];

fid=fopen(str,'r');
if (fid>0)
    dumpnm=str;
    fclose(fid);
    return;
end
warning(['Unable to find anything remotely resembling a dump in ' nm]);    
dumpnm='';



