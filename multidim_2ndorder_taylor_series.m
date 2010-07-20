function[f0,dfdx,d2fdx2]=multidim_2ndorder_taylor_series(func,dx,x0,varargin)

if (~exist('x0'))
    x0=0*dx;
end
if (length(x0)==0)
    x0=0*dx;
end


f0=feval(func,x0,varargin{:});
for j=1:length(x0),
    vec=0*x0;
    vec(j)=1;
    fp{j}=feval(func,x0+vec.*dx,varargin{:});
    fm{j}=feval(func,x0-vec.*dx,varargin{:});
    dfdx{j}= (fp{j}-fm{j})/(2*dx(j));
    d2fdx2{j,j}=(fp{j}+fm{j}-2*f0)/(2*dx(j)^2);
end


for j=1:length(x0),
    for k=j+1:length(x0)
        vec=0*x0;
        vec(j)=1;
        vec(k)=1;
        fp=feval(func,x0+vec.*dx,varargin{:});
        fm=feval(func,x0-vec.*dx,varargin{:});
        
        d1=fp-f0-dfdx{j}*dx(j)-dfdx{k}*dx(k)-d2fdx2{j,j}*dx(j)^2-d2fdx2{k,k}*dx(k)^2;
        d2=fm-f0+dfdx{j}*dx(j)+dfdx{k}*dx(k)-d2fdx2{j,j}*dx(j)^2-d2fdx2{k,k}*dx(k)^2;
        d2fdx2{j,k}=0.5*(d1+d2)/(dx(j)*dx(k));
    end
end

        
