function[vals]=randpow(n,index,x0,xmax)
%Create power-law random deviates.

vals=rand(n);

if (nargin<4)
    vals=vals.^(1/(1+index));
    if (nargin==3)
        vals=x0*vals;
    end
    return;
end

%now do the case if we are constrained, top & bottom
f1=x0^(index+1);
f2=xmax^(index+1);
vals=  (vals*(f2-f1)+f1).^(1/(1+index));

