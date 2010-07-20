function[mat]=tri_inv(a,uplo,opts)
n=size(a);
if (n(1)~=n(2))
    error('Matrix not square in tri_inv');
end
n=n(1);
mat(n,n)=0;

blck_sz=300;
if (nargin>2)
    if isfield(opts,'blocksize')
        block_sz=opts.blocksize;
    end
end
disp(['block size in tri_inv is ' num2str(block_sz)]);
nb=ceil(n/block_sz);

bot=1+block_sz*(0:nb-1);
top=block_sz*(1:nb);
top(nb)=n;


%diag_inv(block_sz,block_sz,nb)=0;
if (lower(uplo(1))=='l')
    for j=1:nb,
        mat(bot(j):top(j),bot(j):top(j))=inv(a(bot(j):top(j),bot(j):top(j)));
        for k=j+1:nb,
            mat(bot(k):top(k),bot(j):top(j))=-inv(a(bot(k):top(k),bot(k):top(k)))*(a(bot(k):top(k),bot(j):top(k))*mat(bot(j):top(k),bot(j):top(j)));
        end
    end
end

if (lower(uplo(1))=='u')
    for j=1:nb,
        mat(bot(j):top(j),bot(j):top(j))=inv(a(bot(j):top(j),bot(j):top(j)));
        for k=j-1:-1:1,
            mat(bot(k):top(k),bot(j):top(j))=-inv(a(bot(k):top(k),bot(k):top(k)))*(a(bot(k):top(k),bot(k):top(j))*mat(bot(k):top(j),bot(j):top(j)));
        end
    end
end


        
