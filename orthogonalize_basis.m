function[base1,base2]=orthogonalize_basis(vecs,do_svd)
m=size(vecs,1);
n=size(vecs,2);
if (n>m)
    vecs=vecs';
    do_swap=1;
    h=m;
    m=n;
    n=h;
else
    do_swap=0;
end

if (nargin<2)
    do_svd=0;
end

if (do_svd)
    %[base1,s,v]=svd(vecs,0);
    [base1,s]=svd(vecs,0);
    if (nargout>1)
        crap=randn(m,m-n);
        fwee=base1'*crap;
        crap=crap-base1*(base1'*crap);
        %whos
        %[base2,s,v]=svd(crap,0);
        [base2,s]=svd(crap,0);
    end
else
    [base1,r]=qr(vecs,0);
    clear r;
    if (nargout>1)
        crap=randn(m,m-n);
        crap=crap-base1*(base1'*crap);
        [base2,r]=qr(crap,0);
        clear r;
        clear crap;
    end
end

