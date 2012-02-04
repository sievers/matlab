function[vec]=get_fft_vec(n)
vec=0:n-1;
if iseven(n)
  vec(vec>n/2)=vec(vec>n/2)-n;
else
  vec(vec>n/2)=vec(vec>n/2)-n;
end
  