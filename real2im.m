function[value]=real2im(vec)
value=vec(1:2:length(vec));
value=value+i*vec(2:2:length(vec));
