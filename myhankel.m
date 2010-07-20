function[vec,r,k,vec_trans,map]=myhankel(fun,rmax,dr,varargin)

r=0:dr:rmax;
vec=fun(r,varargin{:});
k=(0:length(r)-1)/max(r);
vec_trans=0*k;
for j=1:length(k),
    vec_trans(j)=sum(besselj(0,k(j)*r*pi).*vec.*r);
end






rr=[r fliplr(r(2:end))];
rmat=repmat(rr,[numel(rr) 1]);
rmat=sqrt(rmat.^2+rmat'.^2);
map=fun(rmat,varargin{:});
mapft=real(fft2(map));  %better be mostly real, but not perfectly because of roundoff
map=mapft(1,1:length(vec_trans));


return



%vec=[flipud(f(2:end)) ; f];
%mat=repmat(
   
