function[like,curve,deriv,ci_x,chisq,logdet]=get_curve_deriv(spectrum,noise,data_in,wins,template)
format short e
cov=noise;
nbin=size(wins,3);

data=data_in-template*spectrum(nbin+1);

for j=1:nbin,
    cov=cov+spectrum(j)*wins(:,:,j);
end

[r,p]=chol(cov);

if (p==0)
    logdet=0;
    for j=1:max(size(data)),
        logdet=logdet+log(r(j,j));
    end
    crud=chol_solve(r,data);
    if (size(data)==size(crud))
        chisq=-0.5*sum(data.*crud);
    else
        chisq=-0.5*data'*crud';
    end

    %chisq=-0.5*data'*cov_inv*data;
    %[chisq logdet]
    like= chisq-logdet;
    like=-1*like; %for use in fminsearch
%    disp([chisq logdet])
%    like=like-246.822;

else
    like=1e10;
end


%if don't want curvature and gradient, just calculate the likelihood and
%exit
if (nargout>1)        
    cov_inv=inv(cov);
    
    ci_x=cov_inv*data;
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
            curve(j,k)=0.5*cb_ci_x(:,j)'*ci_cb_ci_x(:,k);
            curve(k,j)=curve(j,k);
        end
    end

    curve(nbin+1,nbin+1)=0;
    for j=1:nbin,
        curve(j,nbin+1)=template'*ci_cb_ci_x(:,j);
        curve(nbin+1,j)=curve(j,nbin+1);
    end
    curve(nbin+1,nbin+1)=template'*cov_inv*template;
    deriv(nbin+1)=template'*cov_inv*data;
end


    
