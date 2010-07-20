function[covmat]=get_covmat_struct(chains)
tags=fieldnames(chains);
ntag=length(tags);
covmat(ntag,ntag)=0;
for j=1:ntag,
    for k=j+1:ntag,
        v1=getfield(chains,tags{j});
        v2=getfield(chains,tags{k});
        flub=corrcoef(v1,v2);
        covmat(j,k)=flub(1,2);
        covmat(k,j)=covmat(j,k);
    end
    covmat(j,j)=1;
end
