function[params_fit,FVAL,EXITFLAG,OUTPUT,GRAD,hess]=fminunc_wfixed(func_handle,params,opts,fit_list,varargin)
params_to_fit=params(fit_list>0);


[params_fit,FVAL,EXITFLAG,OUTPUT,GRAD,hss]=...
    fminunc(@wrapper_fun,params_to_fit,opts,params,fit_list,func_handle,varargin{:});
%beta_params_guess,'',data,noise_inv_filt,udump,vdump,rgrid,du,maxu,zdump,theta,beta,4);
params(fit_list>0)=params_fit;
params_fit=params;
hh(1:length(params),1:length(params))=0;
hh(fit_list>0,fit_list>0)=hss;
hess=hh;

return




function[chisq]=wrapper_fun(params,params_org,fit_list,func_handle,varargin)
params_org(fit_list>0)=params;
%params(fit_list==0)=params_org(fit_list==0);
chisq=feval(func_handle,params_org,varargin{:});