function[solved]=chol_solve(l,b)
%solves l l^t x = b

if exist('dpotrs')
  solved=dpotrs(l,b);
  return
end


imax=size(l,1);
u(size(b))=0;
x(size(b,1),size(b,2))=0;
u(1)=b(1)/l(1,1);
for i=2:imax,
    so_far=0;
    for j=1:i-1,
        so_far=so_far+l(j,i)*u(j);
    end
    u(i)=(b(i)-so_far)/l(i,i);
end
u;
x(imax)=u(imax)/l(imax,imax);
for i=imax-1:-1:1,
    so_far=0;
    for j=i+1:imax,
        so_far=so_far+l(i,j)*x(j);
    end
    so_far;
    x(i)=(u(i)-so_far)/l(i,i);
end
solved=x;


        