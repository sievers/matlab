function[r] = poissonrnd(lambda,m,n)

if (nargin<2)
    m=1;
end
if (nargin<3)
    n=m;
end

if (prod(size(lambda)) == 1)
    lambda = lambda(ones(rows*columns,1));
else
    lambda = lambda(:);
end

%Initialize r to zero.
r = zeros(rows, columns);

j = (1:(rows*columns))';   % indices remaining to generate

% For large lambda, use the method of Ahrens and Dieter as
% described in Knuth, Volume 2, 1998 edition.
k = find(lambda >= 15);
if ~isempty(k)
   alpha = 7/8;
   lk = lambda(k);
   m = floor(alpha * lk);

   % Generate m waiting times, all at once
   x = gamrnd(m,1);
   t = x <= lk;

   % If we did not overshoot, then the number of additional times
   % has a Poisson distribution with a smaller mean.
   r(k(t)) = m(t) + poissrnd(lk(t)-x(t));

   % If we did overshoot, then the times up to m-1 are uniformly
   % distributed on the interval to x, so the count of times less
   % than lambda has a binomial distribution.
   r(k(~t)) = binornd(m(~t)-1, lk(~t)./x(~t));
   j(k) = [];
end

