%function[like,curve,deriv,chisq,logdet]=get_curve_deriv_datamat(spectrum,noise,mat_use,wins,sources)

if (size(mat_use,1)~=size(mat_use,2))
    warning(['Data is not a square matrix in get_curve_deriv_datamat.  Calling regular get_curve_deriv']);
    [like,curve,deriv,chisq,logdet]=get_curve_deriv(spectrum,noise,data,wins);
    return;
end




cov=noise;
nbin=size(wins,3);
for j=1:nbin,
    cov=cov+spectrum(j)*wins(:,:,j);
end
%[r,p]=chol(cov);
%
%if (p==0)
%    logdet=0;
%    for j=1:max(size(data)),
%        logdet=logdet+log(r(j,j));
%    end
%    chisq=-0.5*sum(sum(data.*cov_inv));
%    like= chisq-logdet;
%    like=-1*like; %for use in fminsearch
%else
%    like=1e10;
%end

logdet=0;
chisq=0;
like=0;

if (do_sources)
    cov_inv=inverse_projected(cov,sources);
else
    cov_inv=inv(cov);
end



%cidci=cov_inv*data*cov_inv;
%disp(['ci*d*ci(1,1) is ' num2str(cidci(1,1))])
whos

cicb=0*wins;
for j=1:nbin,
    cicb(:,:,j)=wins(:,:,j)*cov_inv;
end
cid=mat_use*cov_inv;
whos
for j=1:nbin,
    deriv(j,1)=0.5*sum(sum(cid'.*cicb(:,:,j)))-0.5*sum(sum(cov_inv.*wins(:,:,j)));
end
for j=1:nbin,
    for k=j:nbin,
        curve(j,k)=-0.5*sum(sum(cicb(:,:,j)'.*cicb(:,:,k)));
        curve(k,j)=curve(j,k);
    end
end
