function[tile]=tile_strip(map,pad_frac)
do_flip=false;
if (size(map,1)>size(map,2))
  do_flip=true;
  map=map';
end
l1=min(size(map));
l2=max(size(map));
nstrip=floor(sqrt(l2/l1));

strip_len=ceil(l2/nstrip);
if (~exist('pad_frac'))
  pad_frac=0.1;
end

pad_len=ceil(pad_frac*l1);

tile(2*pad_len*nstrip+l1*nstrip,   2*pad_len+strip_len)=0;
%whos

tile(:,:)=nan;
%disp([pad_len nstrip strip_len])
for j=1:nstrip,
  if (j<nstrip),
    chunk=map(:,(j-1)*strip_len+1:j*strip_len);
  else
    chunk=map(:,(j-1)*strip_len+1:end);
  end
  whos chunk

  xmin=(2*j-1)*pad_len+1+(j-1)*l1;
  ymin=pad_len+1;
  %disp([xmin ymin size(chunk)])
  tile(xmin+1:xmin+size(chunk,1),ymin+1:ymin+size(chunk,2))=chunk;
end
if (do_flip)
  tile=tile';
end
