function[mat_inv]=invsafe(mat,tol,keep_neg)
[v,e]=eig(mat);
e=diag(e);
if (nargin<2)
     tol=-1e-13;
end

if (tol>0)
  cut=tol;
else
  cut=abs(tol)*max(abs(e));
end
disp(cut)

%disp(e')
disp(['cut ' num2str(sum(abs(e)<abs(tol))) ' modes out of ' num2str(length(e)) ]);
e_inv(abs(e)>=cut)=1./e(abs(e)>=cut);
e_inv(abs(e)<cut)=0;
mat_inv=v*diag(e_inv)*v';
mat=0.5*(mat+mat'); %just make sure it's symmetric
