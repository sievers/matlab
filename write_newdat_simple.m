function[curve]=write_newdat_simple(stuff,fname)
data=stuff.data;  %must have data!

if min(size(data))>1
  bands_guess=repmat(length(data), [1 size(data,2)]);
  bands_guess=[bands_guess repmat(0,[1 6-size(data,2)])];
  bands=get_struct_mem(stuff,'bands',bands_guess);  %guess TT-only  
else
  bands=get_struct_mem(stuff,'bands',[length(data) 0 0 0 0 0]);  %guess TT-only  
end
%pols=get_struct_mem(stuff,'pols',1*(bands>0));
if min(size(data))==1,
  assert(sum(bands)==length(data));
  data_split=split_data_into_bands(data,bands);
else
  data_split=data;
  data=merge_data_from_bands(data_split,bands);
  data_split=split_data_into_bands(data,bands);  %zeroes out things that should have been zero anyways
end

  
if isfield(stuff,'errs')
  [errs,errs_split]=format_bands(stuff.errs,bands);
  curve=get_struct_mem(stuff,'curve',diag(errs.^2));
else
  curve=stuff.curve;  %must have curvature if errors are missing.
  errs=sqrt(diag(curve));
  [errs,errs_split]=format_bands(errs,bands);
end
[errs_upper,errs_upper_split]=format_bands(get_struct_mem(stuff,'errs_upper',errs),bands);


[otherps,otherps_split]=format_bands(get_struct_mem(stuff,'otherps',zeros(size(data_split))),bands);
default_otherps=isfield(stuff,'otherps')*1.0;
iliketype=get_struct_mem(stuff,'iliketype',default_otherps);
if iliketype==2
  [bands_like,bands_like_split]=format_bands(get_struct_mem(stuff,'bands_like',ones(size(data))),bands);
end

calib_error=get_struct_mem(stuff,'calib_error',0.0);
amp_scale=get_struct_mem(stuff,'amp_scale',1.0);
window_name=get_struct_mem(stuff,'window_name','NONE');
band_selection=get_struct_mem(stuff,'band_selection',[]);
sz_freq=get_struct_mem(stuff,'sz_freq',[]);

%beam stuff should be done here


if ~isfield(stuff,'lmin')
  lmin=stuff.ell;
  lmax=stuff.ell+1;
else
  assert(isfield(stuff,'lmax'));
  lmin=stuff.lmin;
  lmax=stuff.lmax;
end
[lmin,lmin_split]=format_bands(lmin,bands);
[lmax,lmax_split]=format_bands(lmax,bands);




pol_tags=['TT'
    'EE'
    'BB'
    'EB'
    'TE'
    'TB'
    'tp'];



fid=fopen(fname,'w');
fprintf(fid,'%s\n',window_name);
fprintf(fid,'%d ',bands);
fprintf(fid,'\n');
if ~isempty(band_selection)
  fprintf(fid,'BAND_SELECTION\n');
  for j=1:size(band_selection,1),
    fprintf(fid,'%2d %2d\n',band_selection(j,1),band_selection(j,2));
  end
end
fprintf(fid,'1 %0.4g %0.4g\n',amp_scale,calib_error);
fprintf(fid,'0 0 0\n');  %beam
fprintf(fid,'%d # iliketype\n',iliketype);
for j=1:length(bands),
  if bands(j)>0
    fprintf(fid,'%s\n',pol_tags(j,:));
    for jj=1:bands(j),
      fprintf(fid,'%3d  %10.3g %10.3g %10.3g %8.3g %5d %5d',jj,data_split(jj,j),errs_split(jj,j),errs_upper_split(jj,j),otherps_split(jj,j),lmin_split(jj,j),lmax_split(jj,j));
      if (iliketype==2)
        fprintf(fid,' %d\n',bands_like_split(jj,j));
      else
        fprintf(fid,'\n');
      end
    end
    corrs=format_corrs(curve,bands,j);  %this may break in pol'n
    for jj=1:length(corrs),
      fprintf(fid,'%8.4g ',corrs(jj,:));
      fprintf(fid,'\n');
    end
  end  
end
for jj=1:length(curve),
  fprintf(fid,'%10.4g ',curve(jj,:));
  fprintf(fid,'\n');
end

if ~isempty(sz_freq)
  fprintf(fid,'#SZ %8.4g\n',sz_freq);
end


fclose(fid);



return


function[vec,vec_split]=format_bands(crud,bands)
if size(crud,2)==1,
  vec_split=split_data_into_bands(crud,bands);
  vec=crud;
else
  vec=merge_data_from_bands(crud,bands);
  vec_split=split_data_into_bands(vec,bands);
end
return


function[data]=merge_data_from_bands(data_split,bands);
if size(data_split,2)==length(bands),
  myinds=1:6;
else
  assert(size(data_split,2)==sum(bands>0));
  myinds=find(bands>0);
end
data=[];
for j=1:length(myinds),  
  data=[data;data_split(1:bands(myinds(j)),j)];
end


function[data_split]=split_data_into_bands(data,bands)

data_split=zeros(max(bands),numel(bands));
cur=0;
for j=1:length(bands),
  data_split(1:bands(j),j)=data(cur+1:cur+bands(j));
  cur=cur+bands(j);
end
return

function[corrs]=format_corrs(curve,bands,ind)
vec=diag(1./sqrt(diag(curve)));
corrs=vec*curve*vec;
imin=sum(bands(1:ind-1));
corrs=corrs(imin+1:imin+bands(ind),imin+1:imin+bands(ind));
return


