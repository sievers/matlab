function[value]=get_likelihood(spec,data,noise,wins)
for j=1:length(spec),
  noise=noise+spec(j)*wins(:,:,j);
end
[r,p]=chol(noise);
if p==0
  logdet=sum(log(diag(r)));
  dd=chol_solve(r,data);
  chisq=sum(dd.*data);
  value=-0.5*chisq-logdet;
else
  value=-1e10;
end

    
