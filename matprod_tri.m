function[mat]=matprod_tri(a,b,uplo_a,uplo_b,opts)

n=size(a);
m=size(b);
if (n~=m)|(n(1)~=n(2))
    warning('Matrices either not square or size mismatch in matprod_tri.  Using regular multiply');
    mat=a*b;
end

n=n(1);

block_sz=300;

if (nargin>4)
    if isfield(opts,'blocksize')
        block_sz=opts.blocksize;
    end
end
disp(['block size in matprod_tri is ' num2str(block_sz)]);

nb=ceil(n/block_sz);

bot=1+block_sz*(0:nb-1);
top=block_sz*(1:nb);
top(nb)=n;


mat(n,n)=0;

uplo_a=isup(uplo_a);
uplo_b=isup(uplo_b);

if (uplo_a)&(uplo_b)
    for j=1:nb,
        fwee=a(bot(j):top(j),bot(j):n);
        for k=j:nb,
            %whos f*
            %disp([j k bot(j) top(j) bot(k) top(k)])
            %crud1=fwee(:,1:top(k));
            %crud2=b(1:top(k),bot(k):top(k));
            %whos c* 
            
           
            mat(bot(j):top(j),bot(k):top(k))=fwee(:,1:top(k)+1-bot(j))*b(bot(j):top(k),bot(k):top(k));
            %disp(mat)
        end
    end
end

if (~uplo_a)&(~uplo_b)
    for j=1:nb,
        fwee=a(bot(j):top(j),1:top(j));
        for k=1:j,                      
            mat(bot(j):top(j),bot(k):top(k))=fwee(:,bot(k):top(j))*b(bot(k):top(j),bot(k):top(k));
            %disp(mat)
        end
    end
end
if (uplo_a)&(~uplo_b)
    for j=1:nb,
        fwee=a(bot(j):top(j),1:n);
        for k=1:nb,
            bot_use=max([bot(j) bot(k)]);
            mat(bot(j):top(j),bot(k):top(k))=fwee(:,bot_use:n)*b(bot_use:n,bot(k):top(k));
        end
    end
end

if (~uplo_a)&(uplo_b)
    for j=1:nb,
        fwee=a(bot(j):top(j),1:n);
        for k=1:nb,
            top_use=min([top(j) top(k)]);
            mat(bot(j):top(j),bot(k):top(k))=fwee(:,1:top_use)*b(1:top_use,bot(k):top(k));
        end
    end
end




return

function[value]=isup(uplo)
uplo=lower(uplo);
value=-1;
if uplo(1)=='u'
    value=1;
end
if (uplo(1)=='l')
    value=0;
end
if (value==-1)
    error('Unrecognized uplo in matprod_tri');
end

