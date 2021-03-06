function[value,names,nbytes]=get_fits_bintable_format(header)

nfield=get_fits_keyval(header,'TFIELDS');
value(nfield)=0;
names=cell(nfield,1);
for j=1:nfield,
  mychar=get_fits_keyval(header,['TFORM' num2str(j)]);
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
if numel(mychar)>1
  if numel(mychar)>2
    disp(['going to puke on ' mychar]);
  end
  assert(numel(mychar)==2);
  assert(mychar(1)=='1');
  mychar=mychar(end);
end


if mychar=='I'
  val=2;
  return;
end
if mychar=='E'
  val=-4;
  return;
end
if mychar=='D'
  val=-8;
  return
end

if mychar=='L'
  val=1;
  return
end


if mychar=='J'
  val=4;
  return
end
if mychar=='B'
  val=1;
  return
end


disp(['unrecognized type in convert_format_char_to_int: ' mychar]);

