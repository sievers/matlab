function[vec_out]=expand_vec(vec_in)

n=max(size(vec_in))/2;
vec_out((n+1):(3*n))=vec_in;
