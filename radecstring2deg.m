function[ra,dec]=radecstring2deg(mystr)
segs=strsplit(mystr,': ');
if length(segs)>=5,
  ra_use=segs(1:3);
  dec_use=segs(4:end);
end
if length(segs)==4
  ra_use=segs(1:2);
  dec_use=segs(3:4);
end

ra=segs2deg(ra_use)*15;
dec=segs2deg(dec_use);

return

function[value]=segs2deg(segs)
isneg=sum(segs{1}=='-');
nseg=length(segs);
vals(nseg,1)=0;
for j=1:nseg,
  vals(j)=abs(str2num(segs{j}));
end

value=vals(1);
for j=2:nseg,
  value=value+vals(j)/60^(j-1);
end
if isneg
  value=-1*value;
end


