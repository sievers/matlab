function[vals]=find_good_fft_lens(max_val,max_prime)
if ~exist('max_prime')
  max_prime=7;
end

crud=[];
for j=2:max_prime,
  crud=[crud factor(j)];
end
myprimes=unique(crud);
imax=floor(log(max_val)./log(myprimes));
nn=prod(imax+1);
vals=zeros(nn,1);
np=length(myprimes);
logfacs=log(myprimes);
for j=0:nn-1,
  jj=j;
  pfacs=zeros(1,np);
  for k=1:np,
    pfacs(k)=mod(jj,imax(k)+1);
    jj=floor(jj/(imax(k)+1));
  end
  vals(j+1)=exp(sum(pfacs.*logfacs));%prod(pfacs);

end
vals=round(sort(vals));
vals=vals(vals<=max_val);
%disp(vals)
    
    