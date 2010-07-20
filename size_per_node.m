function[sz]=size_per_node(mat_size,block_size,nnodes,cores_per_node)
%Calculates the usage for a single double-precision matrix of size mat_size
%in scalapack.  
if (nargin<4)
    cores_per_node=8;
end
ncore=cores_per_node*nnodes;


%find the geometry
factors=factor(ncore);
factors=[1 factors];
best_rat=ncore+1;
nfac=length(factors);
for j=1:2^nfac
    state=getbase2(j,nfac);
    rat=prod(factors(state))/prod(factors(~state));
    if (rat<1)
        rat=1/rat;
    end
    if (rat<best_rat)
        best_rat=rat;
        best_state=state;
    end
end
nprow=prod(factors(best_state));
npcol=prod(factors(~best_state));
%disp(['Best configuration is ' num2str([nprow npcol])]);

%disp('doing rows')
for myrow=0:nprow-1,
    numroc_row(myrow+1)=numroc(mat_size,block_size,nprow,myrow);
end
%disp('doing columns');
for mycol=0:npcol-1,
    numroc_col(mycol+1)=numroc(mat_size,block_size,npcol,mycol);
end

    
for myrow=nprow:-1:1,
    for mycol=npcol:-1:1,
        nelem(myrow,mycol)=numroc_row(myrow)*numroc_col(mycol);
    end
end
%disp(nelem);

mat1=reshape(nelem,[prod(size(nelem)) 1]);
mat2=reshape(nelem',[prod(size(nelem)) 1]);
sz(1)=sum(mat1(1:cores_per_node));
sz(2)=sum(mat2(1:cores_per_node));
sz=sz*8/1024^2;




function[numbase]=getbase2(num,ndigit)
%only works currently for integer input
num=round(num);

%if we haven't specified how many we want, set to the length required by
%the number
if (nargin<2)
    ndigit=ceil(log2(num));
end

numbase(1:ndigit)=false;
for j=ndigit:-1:1,
    if rem(num,2)==1
        numbase(j)=true;
        num=num-1;
    end
    num=round(num/2);
end

        
        
        
function[nelem]=numroc(n,block_size,nprow,myrow)
nblock=floor(n/block_size);
if (block_size*nblock)<n
    last_block=n-(block_size*nblock);
    nblock=nblock+1;
else
    last_block=block_size;
end
myblocks=floor(nblock/nprow);
mylastblock=myblocks*nprow+myrow+1;
%disp([n block_size nblock last_block mylastblock myrow])
if mylastblock<nblock
    myblocks=myblocks+1;    
end
nelem=block_size*myblocks;
if (mylastblock==nblock)
    nelem=nelem+last_block;
end




%nblock=
%
% NBLOCKS = N / NB
% NUMROC = (NBLOCKS/NPROCS) * NB
%      EXTRABLKS = MOD( NBLOCKS, NPROCS )
%      IF( MYDIST.LT.EXTRABLKS ) THEN
%          NUMROC = NUMROC + NB
%      ELSE IF( MYDIST.EQ.EXTRABLKS ) THEN
%          NUMROC = NUMROC + MOD( N, NB )
%      END IF
