function[mat,shift_mat]=shift_mat_fft(mat,dx,dy)
if ~exist('dy') & numel(dx)==2,
  dy=dx(2);
  dx=dx(1);
end
xvec=(0:size(mat,1)-1)';
nn=size(mat,1)/2;
xvec(xvec>nn)=xvec(xvec>nn)-size(mat,1);

yvec=(0:size(mat,2)-1);
nn=size(mat,2)/2;
yvec(yvec>nn)=yvec(yvec>nn)-size(mat,2);

xvec=exp(-2*pi*i*xvec*dx/size(mat,1));
yvec=exp(-2*pi*i*yvec*dy/size(mat,2));

shift_mat=xvec*yvec;

do_real=isreal(mat);

mat=ifft2(fft2(mat).*shift_mat);
if do_real,
  mat=real(mat);
end
