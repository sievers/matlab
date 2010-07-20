function[mat]=legendre_mat(x,ord)
if (max(x)>1)|(min(x)<-1)
    error('x out of range in cholmat');
end
mat(length(x),ord+1)=0;
if size(x,1)==1
    x=x';
end
mat(:,1)=1;
if ord>0,
    mat(:,2)=x;
end
for j=2:ord,
    n=j-1;
    mat(:,j+1)=((2*n+1)*x.*mat(:,j)-(n)*mat(:,j-1))/(n+1);
end
