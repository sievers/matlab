function[xvec,yvec]=get_fft_shift_vecs(sz,dx,dy)
if ~exist('dy') & numel(dx)==2,
  dy=dx(2);
  dx=dx(1);
end
xvec=(0:sz(1)-1)';
nn=sz(1)/2;
xvec(xvec>nn)=xvec(xvec>nn)-sz(1);

yvec=(0:sz(2)-1);
nn=sz(2)/2;
yvec(yvec>nn)=yvec(yvec>nn)-sz(2);

xvec=exp(-2*pi*i*xvec*dx/sz(1));
yvec=exp(-2*pi*i*yvec*dy/sz(2));
