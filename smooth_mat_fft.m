function[mat_smooth]=smooth_mat_fft(mat,oversamp)
mft=fft2(mat);
mft=pad_fft_matrix(mft,oversamp);
mat_smooth=ifft2(mft)*(1+2*oversamp)^2;
if isreal(mat)
  mat_smooth=real(mat_smooth);
end

