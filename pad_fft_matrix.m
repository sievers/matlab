function[mm]=pad_fft_matrix(mm,oversamp)

if iseven(size(mm,1)),
  jj=size(mm,1)/2+1;
  mat(jj,:)=0;
end
if iseven(size(mm,2)),
  jj=size(mm,2)/2+1;
  mat(:,jj)=0;
end

mm=fftshift(mm);
mm=pad_matrix(mm,oversamp);
mm=ifftshift(mm);