function[value,names,nbytes]=get_fits_bintable_format(header)
nfield=get_fits_keyval(header,'TFIELDS');
value(nfield)=0;
names=cell(nfield,1);
for j=1:nfield,
  mychar=get_fits_keyval(header,['TFORM' num2str(j)])
  value(j)=convert_format_char_to_int(mychar);
  names{j}=get_fits_keyval(header,['TTYPE' num2str(j)]);
end


nbytes=sum(abs(value(value<10)))+sum(value(value>10)-10);
assert(nbytes==get_fits_keyval(header,'NAXIS1'));


function[val]=convert_format_char_to_int(mychar)
if mychar(end)=='A'
  val=str2num(mychar(1:end-1))+10;  %if it's > 10, then we've asked for char
  return
end


if mychar=='I'
  val=2;
  return;
end
if mychar=='E'
  val=-4;
  return;
end



