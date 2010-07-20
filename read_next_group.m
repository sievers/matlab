function[value,to_read]=read_next_group(fid,dattype)
if (nargin<2)
    dattype='double';
end
nb=fread(fid,1,'int');
to_read=nb/sizeof(dattype);
value=fread(fid,to_read,dattype);
nb2=fread(fid,1,'int');
if (nb2~=nb)
    error(['Byte mismatch in read_next group - ' num2str(nb) ' and ' num2str(nb2)]);
end
