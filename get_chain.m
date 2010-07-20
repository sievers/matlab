function[kept_params,chisq,neval]=get_chain(params,corr,func_handle,nelem,varargin)

if (size(params,2)>size(params,1))
    doflip=1;
    params=params';
    doflip=1;
else
    doflip=0;
end

 
lims=varargin{1};
whos varargin
varargin=varargin(2:length(varargin));
%isok=is_inside_lims(params,lims)
%return


chisq(nelem,1)=0;
kept_params(nelem,length(params))=0;
if (doflip)
    chisq_last=feval(func_handle,params',varargin{:});
else
    chisq_last=feval(func_handle,params,varargin{:});
end
nkept=0;
[vp,ep]=eig(corr);
ep=diag(sqrt(abs(diag(ep))));
%epinv(abs(diag(ep))<1e-6*max(abs(diag(ep))))=0;

params_last=params;
neval=1;
fac=25;
while (nkept<nelem)
    isok=0;
    n_try=0;
    while (isok==0)
        n_try=n_try+1;
        params_guess=params_last+vp*ep*randn(length(params),1);
        isok=is_inside_lims(params_guess,lims);
    end
    disp(['took ' num2str(n_try) 'tries to get an OK parameter set.']);
    if (doflip)
        chisq_new=feval(func_handle,params_guess',varargin{:});
    else
        chisq_new=feval(func_handle,params_guess,varargin{:});
    end
    %disp([params_guess' chisq_new])

    %disp([neval chisq_last chisq_new exp(-chisq_new+chisq_last)])
    neval=neval+1;
    %disp(neval)
    %disp([chisq_new chisq_last])
    if (chisq_new<chisq_last)|(rand(1)<exp(-0.5*(-chisq_last+chisq_new)))
        nkept=nkept+1;
        if (nkept/fac)==round(nkept/fac)
            disp(nkept);
        end
        kept_params(nkept,:)=params_guess;
        chisq(nkept)=chisq_new;
        chisq_last=chisq_new;
        params_last=params_guess;
    end
end
disp(['Efficiency was ' num2str(nelem/neval)]);



function[isok]=is_inside_lims(params,lims)
isok=1;
for j=1:length(params),
    if (params(j)<lims(j,1))
        isok=0;
    end
    if (params(j)>lims(j,2))
        isok=0;
    end
end
