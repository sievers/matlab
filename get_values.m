function[vals,which_val]=get_values(vec_in,tol)
if (nargin<2)
    tol=1e-2;
end

doflip=0;
if (size(vec_in,2)>size(vec_in,1))
    doflip=1;
    vec_in=vec_in';
end
ind=(1:max(size(vec_in)))';

vec_sort=sortrows([vec_in ind]);
vec=vec_sort(:,1);
vals=0*vec;
vals(1)=vec(1);
last_val=vals(1);
which_val=0*vec;
nvals=1;
which_val(1)=1;
for j=2:max(size(vec)),
    if (vec(j)-last_val<tol)
        which_val(j)=which_val(j-1);
    else
        which_val(j)=which_val(j-1)+1;
        nvals=nvals+1;
        last_val=vec(j);
    end
end
vals=vals(1:nvals);
for j=1:nvals,
    vals(j)=mean(vec(which_val==j));
end
ind=sortrows([vec_sort(:,2) which_val]);
which_val=ind(:,2);
if (doflip)
    which_val=which_val';
end
