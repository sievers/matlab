function[y]=toeplitz_mult(a,x)
%Calculates y =ax for input Toeplitz matrix a (as a vector) and
%vector x.  Runs in nlog(n) time.

aa=[0;flipud(a(2:end));a];
xx=[x;zeros(length(x),1)];

aaft=fft(aa);
xxft=fft(xx);
y=ifft(aaft.*xxft);
y=y(length(x)+1:end);
