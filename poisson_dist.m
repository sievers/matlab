function[value]=poisson_dist(k,x)
value=exp(-x).*x.^k./gamma(k+1);
