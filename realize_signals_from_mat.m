function[ranvecs,v,e]=realize_signals_from_mat(mat,nsims)
if (nargin<2)
    nsims=1;
end
[v,e]=eig(mat);
ee=diag(sqrt(abs(diag(e))));
crud=randn([max(size(mat)) nsims]);
ranvecs=v*(ee*crud);
