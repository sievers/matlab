function[curve,deriv,curve2]=get_expected_curve_deriv_template(spec,noise,wins,f,mat,t)
%t is the template we'll be fitting
%f is the template that is actually in the data
%mat is the matrix that describes the gaussian 
tt=t*t';
ff=f*f';
tf=t*f';
tf=tf+tf';

nmat=size(wins,3);
a=spec(nmat+1);
cov=noise;
for j=1:nmat,
    cov=cov+wins(:,:,j)*spec(j);
end
p=mat+ff+a^2*tt-a*tf;
q=2*a*tt-tf;


if size(spec,1)==1
    spec=spec';
    doflip=1;
else
    doflip=0;
end
cov_inv=inv(cov);

deriv(nmat+1,1)=-0.5*sum(sum(q.*cov_inv));
curve(nmat+1,nmat+1)=-sum(sum(tt.*cov_inv));


cqc=cov_inv*q*cov_inv;
cqc=0.5*(cqc+cqc');  %make sure it's symmetric

cpc=cov_inv*p*cov_inv;
cpc=0.5*(cpc+cpc');
ccb=0*wins;
for j=1:nmat,
    deriv(j)=0.5*sum(sum(cpc.*wins(:,:,j)))-0.5*sum(sum(cov_inv.*wins(:,:,j)));
    curve(j,nmat+1)=-0.5*sum(sum(cqc.*wins(:,:,j)));
    curve(nmat+1,j)=curve(j,nmat+1);
    ccb(:,:,j)=cov_inv*wins(:,:,j);
end
for j=1:nmat,
    for k=1:nmat,
        curve(j,k)=-0.5*sum(sum(ccb(:,:,j)'.*ccb(:,:,k)));
        curve2(j,k)=-0.5*sum(sum(ccb(:,:,j).*ccb(:,:,k)'));
        %curve(k,j)=curve(j,k);
    end
end

