function[value,names,nbytes,nreps]=get_fits_bintable_format_test(header)

nfield=get_fits_keyval(header,'TFIELDS');
value(nfield)=0;
nreps(nfield)=0;
names=cell(nfield,1);
for j=1:nfield,
  mychar=get_fits_keyval(header,['TFORM' num2str(j)]);
  [value(j),nreps(j)]=convert_format_char_to_int(mychar);
  nn=get_fits_keyval(header,['TTYPE' num2str(j)]);
  nn(nn=='-')='_'; %make sure there are no minus signs in field names
  names{j}=nn;
  %names{j}=get_fits_keyval(header,['TTYPE' num2str(j)]);
  
end


%nbytes=sum(abs(value(value<10)))+sum(value(value>10)-10);
n1=abs(value(value<10)).*nreps(value<10);
n2=abs(value(value>10)-10);
nbytes=sum(n1)+sum(n2);
assert(nbytes==get_fits_keyval(header,'NAXIS1'));


function[val,nrep]=convert_format_char_to_int(mychar)
nrep=1;
if mychar(end)=='A'
  val=str2num(mychar(1:end-1))+10;  %if it's > 10, then we've asked for char
  return
end
if numel(mychar)>1
  nrep=str2num(mychar(1:end-1));
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

