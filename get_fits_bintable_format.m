function[value,names]=get_fits_bintable_format(header)
nfield=get_fits_keyval(header,'TFIELDS');
value(nfield)=0;
names=cell(nfield,1);
for j=1:nfield,
  mychar=get_fits_keyval(header,['TFORM' num2str(j)]);
  value(j)=convert_format_char_to_int(mychar);
  names{j}=get_fits_keyval(header,['TTYPE' num2str(j)]);
end

assert(sum(abs(value))==get_fits_keyval(header,'NAXIS1'));


function[val]=convert_format_char_to_int(mychar)
if mychar=='I'
  val=2;
  return;
end
if mychar=='E'
  val=-4;
  return;
end


