function[a,b]=find2d(mat)
vec=find(mat);

n=size(mat,1);
m=size(mat,2);

%b=rem(vec-1,m)+1;
a=mod(vec-1,n)+1;
b=ceil(vec/n);

%value=[rem(find(mat)-1,n)+1 ceil(find(mat)/m)];