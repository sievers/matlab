function[data,header]=read_fits_hdu(fid)
data=[];
header=read_fits_header(fid);
if isempty(header)
  return;
end
if strcmp(get_fits_keyval(header,'XTENSION',''),'BINTABLE')
  data=read_fits_bintable(header,fid);
end
