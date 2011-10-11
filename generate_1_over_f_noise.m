function[vec,ampvec]=generate_1_over_f_noise(nsamp,dt,knee,powlaw)
if ~exist('powlaw')
  powlaw=-1;
end

nuvec=0:nsamp;
nuvec=[nuvec -1*fliplr(nuvec(2:end-1))]';
dnu=1/(dt*nsamp);
nuvec=nuvec*dnu;
x=randn(size(nuvec));
xft=fft(x);
ampvec=abs(nuvec).^powlaw;
ampvec(1)=0;
ampvec=ampvec/((knee/dt)^powlaw);
vec=ifft(xft.*(ampvec));
vec=real(vec(1:nsamp));

