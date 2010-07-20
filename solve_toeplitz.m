function[x]=solve_toeplitz(a1,a2,b)
%solve toeplitz(a1,[a2])x=b for x.  works on non-symmetric, complex
%matrices (though will be faster on real).  Solves  in n^2 time.
%x=solve_toeplitz(a,b) gives same as inv(toeplitz(a))*b
%x=solve_toeplitz(a,aa,b) gives same as inv(toeplitz(a,aa))*b
%Please use column vectors!  

if ~exist('b')
  b=a2;
  a2=conj(a1(2:end));
end


if 0
if ~exist('b')
  b=a2;
  a1=conj(a2(2:end));
end

    whos
    %do some swapping around so that arguments are same as matlab's toeplitz
    if length(a1)==length(a2),
        a2=a2(2:end);
    else
        if length(a2)==1+length(a1),
            a0=a2(1);
            a1=[a0;a1];
            a2=a2(2:end);
        end
    end
end





m=length(b);
c1=zeros(size(b));
c2=zeros(size(b));
x=zeros(size(b));

r1 = a1(1);
x(1) = b(1)/r1;
if (m ==1 ), return; end

for n=2:m,
  n1 = n - 1;
  n2 = n - 2;
  r5 = a2(n1);
  r6 = a1(n);
  if (n~=2)
    c1(n1) = r2;    
    r5=r5+sum(a2(1:n2).*flipud(c1(n-n2:n-1)));
    r6=r6+sum(a1(2:n2+1).*c2(1:n2));
  end    
  r2 = -r5/r1;
  r3 = -r6/r1;
  r1 = r1 + r5*r3;
  if (n~=2),    
    tmp=c2(1:n1-1);
    c2(2:n1)=c1(2:n1)*r3+c2(1:n1-1);
    c1(2:n1)=c1(2:n1)+r2*tmp;    
  end
  c2(1) = r3;
  r5=sum(a2(1:n1).*flipud(x(n-n1:n-1)));
  r6=(b(n)-r5)/r1;
  x(1:n1)=x(1:n1)+c2(1:n1)*r6;
  x(n)=r6;
end







%
%
%      subroutine tsld1(a1,a2,b,x,c1,c2,m)
%      integer m
%      double precision a1(m),a2(1),b(m),x(m),c1(1),c2(1)
%c
%c     tsld1 solves the double precision linear system
%c     a * x = b
%c     with the t - matrix a .
%c
%c     on entry
%c
%c        a1      double precision(m)
%c                the first row of the t - matrix a .
%c                on return a1 is unaltered .
%c
%c        a2      double precision(m - 1)
%c                the first column of the t - matrix a
%c                beginning with the second element .
%c                on return a2 is unaltered .
%c
%c        b       double precision(m)
%c                the right hand side vector .
%c                on return b is unaltered .
%c
%c        c1      double precision(m - 1)
%c                a work vector .
%c
%c        c2      double precision(m - 1)
%c                a work vector .
%c
%c        m       integer
%c                the order of the matrix a .
%c
%c     on return
%c
%c        x       double precision(m)
%c                the solution vector. x may coincide with b .
%c
%c     toeplitz package. this version dated 07/23/82 .
%c
%c     internal variables
%c
%      integer i1,i2,n,n1,n2
%      double precision r1,r2,r3,r5,r6
%c
%c     solve the system with the principal minor of order 1 .
%c
%      r1 = a1(1)
%      x(1) = b(1)/r1
%      if (m .eq. 1) go to 80
%c
%c     recurrent process for solving the system
%c     with the t - matrix for n = 2, m .
%c
%      do 70 n = 2, m
%c
%c        compute multiples of the first and last columns of
%c        the inverse of the principal minor of order n .
%c
%         n1 = n - 1
%         n2 = n - 2
%         r5 = a2(n1)
%         r6 = a1(n)
%         if (n .eq. 2) go to 20
%            c1(n1) = r2
%            do 10 i1 = 1, n2
%               i2 = n - i1
%               r5 = r5 + a2(i1)*c1(i2)
%               r6 = r6 + a1(i1+1)*c2(i1)
%   10       continue
%   20    continue
%         r2 = -r5/r1
%         r3 = -r6/r1
%         r1 = r1 + r5*r3
%         if (n .eq. 2) go to 40
%            r6 = c2(1)
%            c2(n1) = 0.0d0
%            do 30 i1 = 2, n1
%               r5 = c2(i1)
%               c2(i1) = c1(i1)*r3 + r6
%               c1(i1) = c1(i1) + r6*r2
%               r6 = r5
%   30       continue
%   40    continue
%         c2(1) = r3
%c
%c        compute the solution of the system with the
%c        principal minor of order n .
%c
%         r5 = 0.0d0
%         do 50 i1 = 1, n1
%            i2 = n - i1
%            r5 = r5 + a2(i1)*x(i2)
%   50    continue
%         r6 = (b(n) - r5)/r1
%         do 60 i1 = 1, n1
%            x(i1) = x(i1) + c2(i1)*r6
%   60    continue
%         x(n) = r6
%   70 continue
%   80 continue
%      return
%      end
