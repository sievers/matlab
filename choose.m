function[value]=choose(n,m)
value=1;
for j=1:m,
    value=value*(n+1-j)/j;
end
