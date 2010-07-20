function[ind]=get_random_indices(vec,nind)
%If vec is a series of probabilities that one gets that index, then return
%a vector of random indices drawn from that probability distibution.
%Useful for, e.g., drawing samples from a MCMC chain.

if (size(vec,1)<size(vec,2))
    vec=vec';
end

if (~exist('nind'))
    nind=1;
end

y=cumsum(vec);
y=[0;y];
x=(0:length(vec))';

z=rand(nind,1)*y(length(y));
ind=ceil(interp1(y,x,z,'linear'));



