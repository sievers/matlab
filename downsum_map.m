function[mm]=downsum_map(map,fac)
assert(sum(rem(size(map),fac))==0);  %don't try to deal with non-integer oversampling for now.

ss=size(map)/fac;

tmp=zeros(size(map,1),ss(2));
for k=1:fac,
  tmp=tmp+map(:,fac*(1:ss(2))+1-k);
end

mm=zeros(ss);
for k=1:fac,
  mm=mm+tmp(fac*(1:ss(2))+1-k,:);
end
