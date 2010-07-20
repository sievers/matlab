function[mat]=cholmat(x,ord)
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
    mat(:,j+1)=2*x.*mat(:,j)-mat(:,j-1);
end
