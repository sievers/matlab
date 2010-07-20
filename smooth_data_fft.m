function[smoothed_data,width]=smooth_data_fft(data,width)
if length(width)==1
    if (width<1),
        width=floor(width*length(data));
    end
    width=fft(get_gaussvec(length(data),width));
end
smoothed_data=ifft(fft(data).*repmat(width,[1 size(data,2)]));



function[vec]=get_gaussvec(len,width)
vec=fftshift((0:len-1)'-len/2);
vec=exp(-0.5*vec.^2/width);
vec=vec/sum(vec);
