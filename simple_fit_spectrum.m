function[spec,curve,deriv,like]=simple_fit_spectrum(data,noise,wins,spec)
if (nargin<4)
    spec=zeros(size(wins,3),1);
end
converged=0;
niter=0;
maxiter=30;
if size(data,2)==1,
    data=data';
end

if size(spec,2)==1,
    flip_spec=1;
    spec=spec';
else
    flip_spec=0;
end

tol=0.01;
while (converged==0)&(niter<=maxiter)
    niter=niter+1;
    [like,curve,deriv]=get_curve_deriv(spec,noise,data,wins);
    dx=deriv*inv(curve);
    frac=abs(dx'./sqrt(abs(diag(inv(curve)))));
    if max(abs(frac))<tol
        converged=1;
    end
    spec=spec+dx;
    disp(['current spec is ' num2str(spec) ' with maximum shift ' num2str(max(abs(frac))) ]);
end
if (flip_spec)
    spec=spec';
end
