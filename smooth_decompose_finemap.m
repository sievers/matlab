function[emat_mom,bmat_mom,emat,bmat,finemap_smooth,finemap_smooth_real]=smooth_decompose_finemap(finemap,rconv)

finemap_smooth=conv2(finemap,rconv);
finemap_smooth_real=fftshift(ifft2(ifftshift(finemap_smooth)));
emat=real(finemap_smooth_real);
bmat=imag(finemap_smooth_real);

emat_mom=fftshift(fft2(ifftshift(emat)));
bmat_mom=fftshift(fft2(ifftshift(bmat)));
