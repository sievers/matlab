function[map]=jconv2(im1,im2,shape)
if max(size(im2))==1,
    map=im1*im2;
    return
end

if ~exist('shape')
    shape='same';
end

map1=pad(im1,im2);
map1ft=fft2(map1);
clear map1;
map2=pad(im2,im1);
map2ft=fft2(ifftshift(map2));
clear map2;
map=ifft2(map2ft.*map1ft);

if (~iseven(size(im1,1))&~iseven(size(im2,1)))
    map=map([end 1:end-2],:);
    
else
    map=map(1:end-1,:);
end



if (~iseven(size(im1,2))&~iseven(size(im2,2)))
    map=map(:,[end 1:end-2]);
    
else
    map=map(:,1:end-1);
end


%map=map(1:end-1,1:end-1);

if strcmp(shape,'same')
    map=unpad(map,im2);
end







function[map]=pad(im,n,m)
if min(size(n))>1,
    if exist('m')
        warning('skipping m in pad inside jconv2');
    end
    m=size(n,2);
    n=size(n,1);
end
    
if (~exist('m'))
    m=n;
end
n1=floor(n/2);
m1=floor(m/2);

na=size(im,1);
ma=size(im,2);
%[na n ma m]
map(na+n,ma+m)=0;
map(n1+1:n1+na,m1+1:m1+ma)=im;


function[map]=unpad(im1,n,m)

if min(size(n))>1,
    if exist('m')
        warning('skipping m in pad inside jconv2');
    end
    m=size(n,2);
    n=size(n,1);
end

if (~exist('m'))
    m=n;
end
n1=floor((n)/2);
n2=n-n1;
m1=floor((m)/2);
m2=m-m1;

map=im1(n1+1:end+1-n2,m1+1:end+1-m2);



