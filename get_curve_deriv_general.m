function[varargout]=get_curve_deriv_general(spec,data,noise,wins,opts,srcvecs,datavecs)

%first, check sizes
if (size(data,1)==1)
    data=data';
end
n=length(data);
nbin=length(spec);

if (min(size(noise)==n)==0)
    error('Size mismatch in noise in get_curve_deriv_general.');
end
if (size(wins,1)~=n)|(size(wins,2)~=n)
    error('Matrix size mismatch in signal matrices in get_curve_deriv_general.');
end
if (size(wins,3)~=nbin)
    error('Number of bins mismatch in get_curve_deriv_general.m');
end

if (exist('srcvecs')&(length(srcvecs)>0))
    do_sherwood=1;
    add_sources=0;
    if (size(srcvecs,1)~=n)
        srcvecs=srcvecs';
    end
    if (size(srcvecs,1)~=n)
        error('Source vector mismatch in get_curve_deriv_general.');
    end
    %check to see if source matrix is square.  If it is, then probably
    %don't want to do Sherman-Woodbury (as A^-1 will be 0!)
    %don't currently support partial addition, partial projection.  If you
    %want this, then add the partial addition into the noise matrix!
    if min(size(srcvecs)==n)
        add_sources=1;
        do_sherwood=0;
    end
else
    do_sherwood=0;
    add_sources=0;
end

nmin=min(size(data));
if (nmin==n)
    do_datamat=1;
else
    if (nmin==1)
        do_datamat=0;
    else
        error('Data is rectangular in get_curve_deriv_general.');
    end
end

%OK - sizes check out.  Now make sure options are OK.
if (~exist('opts'))
    opts='';
end
opts=do_default_opts_curve_deriv(opts);


%finally, check jobs.  Choices are:  1 output = likelihood,
%2=curvature/derivative, 3=curve,deriv,like, 4=curve,deriv,like,inverse cov
if (nargout==1)
    dolike=1;
    docurve=0;
end
if (nargout==2)
    dolike=0;
    docurve=1;
end
if (nargout>=3)
    dolike=1;
    docurve=1;
end



%Now do real work.
cov=noise;
for j=1:nbin,
    cov=cov+spec(j)*wins(:,:,j);
end
if (add_sources)
    cov=cov+opts.SrcAmp*srcvecs;
end

if (do_datamat)
    if (opts.AddNoiseToData)
        data=data+noise;
    end
end

%no matter what, we have to do a Cholesky
[r,p]=chol(cov);
if (p)
    error('Covariance matrix not positive-definite.');
end

if (do_datamat==0)
   cinv_x=chol_solve(r,data);
   chisq=sum(cinv_x.*data);
   logdet=2*sum(log(diag(r)));
   like=-0.5*chisq-0.5*logdet;
end
logdet=2*sum(log(diag(r)));

%if we only have to do likelihood for a normal run, we're done, so go home.
if (dolike==1)&(docurve==0)&(do_datamat==0)&(do_sherwood==0)
    [like chisq logdet]
    varargout(1)={like};
    return
end

if (opts.BlockInv)
    r=tri_inv(r,'u',opts);
    cov_inv=matprod_tri(r,r','u','l',opts);
    clear r;
else
    clear r;
    cov_inv=inv(cov);
end
if (do_datamat)
    chisq=sum(sum(data.*cov_inv));    
    like=-0.5*chisq-0.5*logdet;
    [like chisq logdet]
    if (dolike==1)&(docurve==0)&(do_sherwood==0)
        varargout(1)={like};
        return;
    end
        
end

if (do_sherwood)
    small_mat=inv(srcvecs'*cov_inv*srcvecs);
    cov_inv=cov_inv-(cov_inv*srcvecs)*small_mat*(srcvecs'*cov_inv);
    if (~do_datamat)
        cinv_x=cov_inv*data;
        chisq=sum(cinv_x.*data);
        like=-0.5*chisq-0.5*logdet;
        if (dolike==1)&(opts.ExactLike==0)
            varargout(1)={like};
        end
        if (dolike==1)&(opts.ExactLike)
            e=sort(eig(cov_inv));
            logdet=sum(log(e(length(small_mat)+1:length(e))));
            like=-0.5*chisq+0.5*logdet;
            varargout(1)={like};
            if (docurve==0)
                return;
            end            
        end        
    end
end
disp(['do curve is ' num2str(docurve)]);
if (docurve)
    if (~do_datamat)
        [curve,deriv]=curve_deriv_frominv(data,cov_inv,wins);
    else
        mat=cov_inv*data*cov_inv;
        for j=size(wins,3):-1:1,
            deriv_chisq(j,1)=0.5*sum(sum(mat.*wins(:,:,j)));
            deriv_logdet(j,1)=0.5*sum(sum(cov_inv.*wins(:,:,j)));
            %deriv(j,1)= 0.5*sum(sum(mat.*wins(:,:,j)))-0.5*sum(sum(cov_inv.*wins(:,:,j)));
        end
        deriv=deriv_chisq-deriv_logdet;
        [deriv deriv_chisq deriv_logdet]
        %if we're getting the curvature from monte-carloed data vectors, do
        %it now.
        %if (exist('datavecs')&(~opts.TrueCurve))
        if (exist('datavecs'))
            curve=0;
            for j=1:size(datavecs,2),
                curve=curve+curve_deriv_frominv(datavecs(:,j),cov_inv,wins);
            end
            curve=curve/size(datavecs,2);
        end
    end
end
if (opts.TrueCurve)
    tracecurve=trace_curve_frominv(cov_inv,wins);
    varargout(4)={tracecurve};
end

if (dolike&docurve)
    varargout(1)={like};
    varargout(2)={curve};
    varargout(3)={deriv};
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[opts_out]=do_default_opts_curve_deriv(opts)
if (~isfield(opts,'SrcAmp'))
    opts.SrcAmp=1e6;
end

if (~isfield(opts,'TrueCurve'))
    opts.TrueCurve=0;
end

if (~isfield(opts,'AddNoiseToData'))
    opts.AddNoiseToData=0;
end

%if you have Sherman-Woodbury, likelihood is ill-defined, as there are
%zeros in the covariance.  One needs to do an eigen decomposition and then
%zero out the low-weight modes.
if (~isfield(opts,'ExactLike'))
    opts.ExactLike=0;
end



if (~isfield(opts,'BlockInv'))
    opts.BlockInv=0;
end
%set the block size to be used in doing the block-diagonal cholesky inverse
if (~isfield(opts,'blocksize'))
    opts.blocksize=0;
end

%set the number of monte-carlo simulations to use in calculating the
%curvature if fitting to a matrix.
if (~isfield(opts,'nsim'))
    opts.nsim=10;
end

opts_out=opts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[curve,deriv]=curve_deriv_frominv(data,cov_inv,wins)
%calculate the gradient and curvature from the inverse covariance, a data
%vector, and the signal matrices.
nwin=size(wins,3);
cix=cov_inv*data;
for j=nwin:-1:1,
    cbcix(:,j)=wins(:,:,j)*cix;
end
cicbcix=cov_inv*cbcix;
for j=nwin:-1:1,
    %deriv(j,1)=0.5*cix'*cbcix(:,j)-0.5*sum(sum(cov_inv.*wins(:,:,j)));
    deriv_chisq(j,1)=0.5*cix'*cbcix(:,j);
    deriv_logdet(j,1)=0.5*sum(sum(cov_inv.*wins(:,:,j)));
end
deriv=deriv_chisq-deriv_logdet;

[deriv deriv_chisq deriv_logdet]
curve=-0.5*cicbcix'*cbcix;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[curve]=trace_curve_frominv(cov_inv,wins)
cicb=0*wins;
nb=size(wins,3);

for j=1:nb,
    cicb(:,:,j)=cov_inv*wins(:,:,j);
end

curve(nb,nb)=0;
for j=1:nb,
    for k=j:nb,
        curve(j,k)=sum(sum(cicb(:,:,j)'.*cicb(:,:,k)));
        curve(k,j)=curve(j,k);
    end
end
clear cicb;
