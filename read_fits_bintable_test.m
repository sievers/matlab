function[value]=read_fits_bintable_test(header,fid)
%if we just get a string in, assume we want the first bintable
if ~exist('fid')
  if ischar(header)
    fname=header;
    fid=fopen(fname);
    h=read_fits_header(fid);
    h2=read_fits_header(fid);
    value=read_fits_bintable_test(h2,fid);
    fclose(fid);
    return
  end
end


[aaa,bbb,nbytes_row,nrep]=get_fits_bintable_format_test(header);

nrow=get_fits_keyval(header,'NAXIS2');
nbyte_raw=nrow*nbytes_row; %sum(abs(aaa));
nbyte=2880*ceil(nbyte_raw/2880);
mystr=fread(fid,[nbyte 1],'*uchar');

mystr=mystr(1:nbyte_raw);
mystr_org=mystr;


aaa_use=aaa;aaa_use(aaa_use>10)=aaa_use(aaa_use>10)-10;
for j=1:length(aaa_use),
  nbyte_chunk(j)=nrep(j)*abs(aaa_use(j));
end

istart=1;
istop=nbyte_chunk(1);
for j=2:length(nbyte_chunk),
  istart(end+1)=istop(end)+1;
  istop(end+1)=istop(end)+nbyte_chunk(j);
end

crud=reshape(mystr,[nbytes_row nrow]);
%crud=reshape(mystr,[nrow nbytes_row]);


for j=1:length(aaa_use),
  mychunk=crud(istart(j):istop(j),:);
  %mychunk=crud(:,istart(j):istop(j));
  if abs(aaa(j))<10,
    mychunk=convert_char_to_num_fits(mychunk,aaa(j))';
  end
  eval(['value.' bbb{j} ' = mychunk;']);
end
return

