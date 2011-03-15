function[data,extname]=read_fits_hdu(fid)
data=[];
[header,values]=read_fits_header(fid);
if isempty(header)
  return;
end
if strcmp(get_fits_keyval(header,'XTENSION',''),'BINTABLE')
  data=read_fits_bintable(header,fid);
  return
end
if strcmp(get_fits_keyval(header,'XTENSION',''),'IMAGE')
  %disp('reading image');
  bitpix=(get_fits_keyval(header,'BITPIX',''));
  naxis=(get_fits_keyval(header,'NAXIS',''));
  myax=zeros(naxis,1);
  for j=1:naxis,
    myax(j)=(get_fits_keyval(header,['NAXIS' num2str(j)],''));
  end

  bitpix2str(bitpix);
  data=fread(fid,myax,bitpix2str(bitpix));
  nread=abs(bitpix)/8*prod(myax);
  crud=2880-rem(nread,2880);
  if crud<2880,
    crap=fread(fid,[crud 1],'char');
  end

  extname=get_fits_keyval(header,'EXTNAME','');
end





function[mystr]=bitpix2str(bitpix)
switch(bitpix)
  case(-64)
   mystr='double';
   break;
 case(-32)
  mystr='float';
  break;
 case(32)
  mystr='int';
  break;
 case(16)
  mystr='short';
  break;
 case(64)
  mystr='long';
  break
 otherwise
  error(['unsupported bitpix ' num2str(bitpix)]);
end
