function[ncont,vals,starts]=how_many_conts(cont)
ind=1;
ncont=0;
while (ind < size(cont,2)),
    ncont=ncont+1;
    starts(ncont)=ind;
    vals(ncont)=cont(1,ind);
    ind=ind+1+cont(2,ind);
end
if (ncont==0)
    vals=0;
    starts=0;
end
