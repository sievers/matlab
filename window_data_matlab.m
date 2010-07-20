function[data,vec]=window_data(data,width,type)
if ~exist('width')
    width=0.01;  %default to 1% windowing.
end
n=size(data,1);
m=size(data,2);
if (width<1),
    nn=floor(n*width);
end
vec=(0:nn-1)'/nn;vec=0.5-0.5*cos(pi*vec);
data(1:nn,:)=data(1:nn,:).*repmat(vec,[1 m]);
data(end-nn+1:end,:)=data(end-nn+1:end,:).*repmat(flipud(vec),[1 m]);
