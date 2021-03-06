function[like,curve,deriv,chisq,logdet]=get_curve_deriv(spectrum,noise,data,wins)
%format short e
%disp(spectrum)
cov=noise;
%disp(spectrum)
%nbin=max(size(spectrum));
nbin=size(wins,3);
for j=1:nbin,
    cov=cov+spectrum(j)*wins(:,:,j);
end

deriv(size(spectrum,1),size(spectrum,2))=0;

[r,p]=chol(cov);

if (p==0)
    cov_inv=inv(cov);
    logdet=0;
    for j=1:max(size(data)),
        logdet=logdet+log(r(j,j));
    end
    chisq=-0.5*data*cov_inv*data';
    like= chisq-logdet;
    like=-1*like; %for use in fminsearch
%    disp([chisq logdet])
%    like=like-246.822;

else
    like=1e10;
    curve=0;
    deriv=0;
    
end

        
        
ci_x=cov_inv*data';
for j=nbin:-1:1,
    cb_ci_x(:,j)=wins(:,:,j)*ci_x;
    ci_cb_ci_x(:,j)=cov_inv*cb_ci_x(:,j);
end
for j=nbin:-1:1,
    deriv(j)=0.5*(ci_x'*wins(:,:,j)*ci_x-sum(sum(cov_inv.*wins(:,:,j))));
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


    
