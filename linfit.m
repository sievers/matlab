function[params]=linfit(y,mat,noise)
%linfit(y,mat,[noise])
%Calculate the linear least-squares fit to a set of data

if exist('noise')
  n=length(y);
  if isvector(noise),
    assert(length(y)==length(noise))
    if size(noise,1)==1,
      noise=noise';
    end
    
    ninv=spdiags(1./noise,0,n,n);
    mat=ninv*mat;
    y=ninv*y;
  else
    crud=inv(chol(noise));
    mat=(crud)*mat;
    y=crud*y;
    clear crud;
  end
end

        

[q,r]=qr(mat,0);
params=inv(r)*(q'*y);

