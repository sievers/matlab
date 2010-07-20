function[value]=read_fits_bintable(header,fid)

[aaa,bbb]=get_fits_bintable_format(header);
nrow=get_fits_keyval(header,'NAXIS2');
nbyte=nrow*sum(abs(aaa));
nbyte=2880*ceil(nbyte/2880);
mystr=fread(fid,[nbyte 1],'*uchar');
flub=convert_fits_bintable(mystr,aaa,nrow);
flub=flub';
for j=1:length(bbb)
  eval(['value.' bbb{j} ' = flub(:,' num2str(j) ');']);
end

