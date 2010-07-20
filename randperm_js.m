function[value]=randperm_js(n)
x=rand([n 1]);
y=(1:n)';
z=sortrows([x y]);
value=z(:,2);
