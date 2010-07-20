function[like,deriv,curve,chisq,logdet]=get_curve_deriv(spectrum,noise,data,wins)
cov=noise;
nbin=size(wins,3);
for j=1:nbin,
    cov=cov+spectrum(j)*wins(:,:,j);
end

deriv(size(spectrum,1),size(spectrum,2))=0;

[r,p]=chol(cov);
if ((p==0)&(nargout==1))
    logdet=0;
    for j=1:max(size(data)),
        logdet=logdet+log(r(j,j));
    end
    data_sl=chol_solve(r,data);

    %like=-0.5*sum(data_sl.*data)-logdet;
    like=-0.5*sum((data_sl-data).*data)-logdet;
    like=-1*like;
    return;
end

if (p==0)
    
    cov_inv=inv(cov);
    logdet=0;
    for j=1:max(size(data)),
        logdet=logdet+log(r(j,j));
    end
    chisq=-0.5*data*cov_inv*data'+0.5*sum(data.^2);
    data_sl=chol_solve(r,data);
    chisq2=-0.5*sum(data_sl.*data);

    %[chisq-chisq2] %not a bad proxy for how noisy the chi^2 calculation is
    like= chisq-logdet;
    like=-1*like; %for use in fminsearch
%    disp([chisq logdet])
%    like=like-246.822;
else
    like=1e10;
    curve=1e10;
    deriv=1e10;
    return
end

        
        
ci_x=cov_inv*data';
for j=nbin:-1:1,
    cb_ci_x(:,j)=wins(:,:,j)*ci_x;
    ci_cb_ci_x(:,j)=cov_inv*cb_ci_x(:,j);
end
for j=nbin:-1:1,
    deriv(j)=0.5*(ci_x'*wins(:,:,j)*ci_x-sum(sum(cov_inv.*wins(:,:,j))));
end
deriv=-1*deriv; %flip sign for minimization instead of maximization
if (nargout==2)
    return
end

curve(nbin,nbin)=0;
for j=1:nbin,
    for k=j:nbin,
        curve(j,k)=cb_ci_x(:,j)'*ci_cb_ci_x(:,k);
        curve(k,j)=curve(j,k);
    end
end
disp(like)
matprod=0*wins;
for j=1:nbin,
  matprod(:,:,j)=cov_inv*wins(:,:,j);
end
curve_trace(nbin,nbin)=0;
for j=1:nbin,
  for k=j:nbin,
    curve_trace(j,k)=sum(sum(matprod(:,:,j)'.*matprod(:,:,k)));
    curve_trace(k,j)=curve_trace(j,k);
  end
end
%curve_trace
%curve
curve=curve-0.5*curve_trace;

curve=-1*curve;%flip sign for minimization vs. maximization

    
