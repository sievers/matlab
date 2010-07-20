function[good_data]=merge_dumps_sources(froot1,froot2,outroot,expand_mats)

nwrote=0;
ncheck=0;

fid1=fopen([froot1 '_Fsrc.dmp'],'r');
fid2=fopen([froot2 '_Fsrc.dmp'],'r');


[sdump1,udump1,vdump1,zdump1]=read_tt_dump_svec(froot1);
[sdump2,udump2,vdump2,zdump2]=read_tt_dump_svec(froot2);
zdump=[zdump1;zdump2];

    
if (~exist('expand_mats'))
    expand_mats=0;
end

if ((fid1==-1)|(fid2==-1))       
    warning(['Fsrc not present in merge_dump_sources.']);
    have_sub=0;
    if (fid1~=-1)
        fclose(fid1);
    end
    if (fid2~=-1)
        fclose(fid2);
    end
else
    fclose(fid1);
    fclose(fid2);
    have_sub=1;
    [src1,nsrc1,nest1,dist1]=read_tt_dump_sources(froot1,0);
    [src2,nsrc2,nest2,dist2]=read_tt_dump_sources(froot2,0);
    srcsub=merge_one_source(src1,src2,dist1,dist2,1,outroot,0);  %if we subtracted, always turn correlations on
    srcsub=sum(srcsub,2); %calculate the source vecs to be subtracted
end

good_data.sdump=[sdump1;sdump2];
good_data.udump=[udump1;udump2];
good_data.vdump=[vdump1;vdump2];
good_data.zdump=[zdump1;zdump2];
good_data.srcsum=srcsub;
good_data
zz=reshape([good_data.zdump good_data.zdump]',[2*length(good_data.zdump) 1]);
zcut=0;
ind=zz>zcut;
ind1=good_data.zdump>zcut;
whos
vec=good_data.sdump-good_data.srcsum;
good_data.data=vec(ind)./zz(ind);
good_data.u=good_data.udump(ind1);
good_data.v=good_data.vdump(ind1);
good_data.z=good_data.zdump(ind1);




nsource1=how_many_files([froot1 '_Dsrc_'],'.dmp');
nsource2=how_many_files([froot2 '_Dsrc_'],'.dmp');
if (nsource1~=nsource2)
    error(['Number of sources mismatch in merge_dumps_sources with ' num2str([nsource1 nsource2])]);
else
    nsource=nsource1;
end

if (length(expand_mats)<nsource)
    expand_mats(length(expand_mats)+1:nsource)=expand_mats(length(expand_mats));
end

for j=1:nsource,
    [src1,nsrc1,nest1,dist1]=read_tt_dump_sources(froot1,j);
    [src2,nsrc2,nest2,dist2]=read_tt_dump_sources(froot2,j);
    
    if (expand_mats(j))
        if (expand_mats(j)==1)
          vecs=merge_one_source(src1,src2,dist1,dist2,1,outroot,2*j-1);
               merge_one_source(src1,src2,dist1,dist2,0,outroot,2*j);
        else
               merge_one_source(src1,src2,dist1,dist2,1,outroot,2*j-1);
          vecs=merge_one_source(src1,src2,dist1,dist2,0,outroot,2*j);
        end
        disp(['Expanding source matrix ' num2str(j)]);
        make_write_srcmat(vecs,outroot,nwrote,zdump);
        nwrote=nwrote+1;
    else
        merge_one_source(src1,src2,dist1,dist2,1,outroot,2*j-1);
        merge_one_source(src1,src2,dist1,dist2,0,outroot,2*j);
    end
    clear vecs
    clear src1
    clear src2;
end

        
    
    
    
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[src1,dist]=merge_one_source(src1,src2,dist1,dist2,do_combine,outroot,matnum)
if (do_combine)
    if size(src1,2)~=size(src2,2)
        error('Size mismatch in combining sources in merge_dumps_sources (merge_one_source)');
    end
    src1=[src1;src2];
    dist=min([dist1 dist2]')';
else
    if size(src1,2)~=size(src2,2)
        warning('Size mismatch in combining sources in merge_dumps_sources (merge_one_source).  Not being merged, so may be ok...');
    end
    src1(size(src1,1)+1:size(src1,1)+size(src2,1),size(src1,2)+1:size(src1,2)+size(src2,2))=src2;
    dist=[dist1;dist2];
end
write_tt_dump_sources(outroot,src1,matnum,dist);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[value]=make_write_srcmat(srcvecs,outroot,matnum,z,zcut)
if (~exist('zcut'))
    zcut=0;
end
if (~exist('z'))
    z=ones(size(srcvecs,1)/2,1);
end

ncut=sum(z<=zcut);
zz=reshape([z z]',[2*length(z) 1]);

if (ncut)
    ind=zz>zcut;
    srcvecs=srcvecs(ind,:);
    zz=zz(ind);
end

for j=1:size(srcvecs,2),
    srcvecs(:,j)=srcvecs(:,j)./zz;
end
srcmat=srcvecs*srcvecs';
clear srcvecs;
fname=[outroot '.source_' num2str(matnum)]
write_single_mat(fname,srcmat,0,5000);
system(['rm -f ' fname '.gz; gzip ' fname ' &']);


