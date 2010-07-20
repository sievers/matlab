function[dat,v,e]=create_fake_data(mat,nsim,doeig)

if (nargin<2)
    nsim=1;
end
if (~exist('doeig'))
    if (nargout<=1)
        doeig=0;
    else
        doeig=1;
    end
end

if (doeig==1)
    
    [v,e]=eig(mat);
    wt=diag(e);
    wt(wt<0)=0;
    wt=sqrt(wt);
    n=max(size(mat));
    ranmat=randn(n,nsim);
    for j=1:n,
        ranmat(j,:)=ranmat(j,:)*wt(j);
    end
    dat=v*ranmat;
else
    if (doeig==2)
        disp('doing LU')
        [l,u,p]=lu(mat,'vector');
        if sum(diag(p))~=length(p)
            error('matrix has been permuted in lu randomization');
        end
        clear p
        u=diag(u);
        u(u<0)=0;
        u=sqrt(u);
        for j=1:length(u),
            l(:,j)=l(:,j)*u(j);
        end        
        n=max(size(mat));
        ranmat=randn([n nsim]);
        %dat=(ranmat'*l')';
        dat=l*ranmat;
        
        
    else
        disp('doing cholesky');
        r=chol(mat);
        n=max(size(mat));
        ranmat=randn([n nsim]);
        %do weird transposing to avoid creating r'
        dat=(ranmat'*r)';
        if (nargout>1)
            warning('Warning - cholesky requested in create_fake_data, but eigenvalues/vectors requested.');
            v='';
            e='';
        end
    end
end

    
    

