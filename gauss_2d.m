function[map]=gauss_2d(sig,sz)
%Make a 2-d gaussian box with half-size sz, and gaussian width sig.
%if sz is not specified, will be something like a few times sigma.

if (~exist('sz'))
    sz=3*ceil(sig);
end
vec=-sz:sz;
x=repmat(vec,[length(vec) 1]);
%imagesc(x);
rsq=x.^2+(x').^2;
map=exp(-0.5*rsq/sig^2);

    