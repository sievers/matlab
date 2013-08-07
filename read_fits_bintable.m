function[value]=read_fits_bintable(header,fid)

[aaa,bbb,nbytes_row]=get_fits_bintable_format(header);

nrow=get_fits_keyval(header,'NAXIS2');
nbyte_raw=nrow*nbytes_row; %sum(abs(aaa));
nbyte=2880*ceil(nbyte_raw/2880);
mystr=fread(fid,[nbyte 1],'*uchar');

mystr=mystr(1:nbyte_raw);
mystr_org=mystr;
if (max(aaa)>10) %extract character arrays
  ind=find(aaa>10);
  %aause=aaa;aause(ind)=aause(ind)-10;
  aause=abs(aaa);aause(ind)=aause(ind)-10;
  offsets=cumsum(aause);offsets=[0 offsets];
  
  crud=reshape(mystr,[nbytes_row nrow])';

  keep_vec=ones(1,nbytes_row);

  for j=1:length(ind),
    ivec=1+offsets(ind(j)):offsets(ind(j)+1);
    keep_vec(ivec)=0;
    mymat=crud(:,ivec);
    eval(['value.' bbb{ind(j)} ' = mymat;']);        
  end
  if sum(keep_vec)>0,
    crud=crud(:,keep_vec>0);
  else
    return;  %finished, only have strings
  end

  
  
  mystr=reshape(crud',[numel(crud) 1]);
  bbb=bbb(aaa<10);
  aaa=aaa(aaa<10);

end

flub=convert_fits_bintable(mystr,aaa,nrow);
flub=flub';
for j=1:length(bbb)
  eval(['value.' bbb{j} ' = flub(:,' num2str(j) ');']);
end

