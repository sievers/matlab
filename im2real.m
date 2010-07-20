function[bigvec]=im2real(vec)
n=max(size(vec));
bigvec(2:2:2*n)=imag(vec);
bigvec(1:2:2*n-1)=real(vec);