function[ps_good,rvec_good]=power_2d(mat)
%calculate the power spectrum of a 2-d image.
if size(mat,1)~=size(mat,2)
    error('Not set up to deal with rectangular maps.');
end
mapft=fftshift(fft2(mat));
n=length(mat);
x=(1:n)-ceil(n/2);
rmat=sqrt(repmat(x.^2,[n 1])+repmat(x'.^2,[1 n]));
rmat=fftshift(rmat);

mapvec=reshape(mapft,[n^2 1]);
clear mapft

rvec=reshape(rmat,[n^2 1]);
clear rmat
mapvec=mapvec.*conj(mapvec);  %square things and make them real

rvec=round(rvec);
stuff=sortrows([mapvec rvec],2);
whos stuff
plot(diff(stuff(:,2)))

ind=(1:length(stuff))';
startvec=ind(diff(stuff(:,2))==1);
startvec(end+1)=length(stuff);
startvec=[0;startvec];
vec=sort(unique(stuff(:,2)));
for j=length(vec):-1:1,
    ps_good(j,1)=mean(stuff((startvec(j)+1):(startvec(j+1)),1));
end
rvec_good=vec;

