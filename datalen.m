function[value]=datalen(vec)
vec1=vec(1:2:length(vec));
vec2=vec(2:2:length(vec));
value=sqrt(vec1.^2+vec2.^2);
