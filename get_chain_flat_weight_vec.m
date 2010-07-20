function[vec]=get_chain_flat_weight_vec(vec_in)
%create a vector that has the weights of the chain expanded, so random
%samples can be drawn from the underlying chain using randperm

vec(sum(vec_in),1)=0;
ind=0;
for j=1:length(vec_in)
    vec(ind+1:ind+vec_in(j))=j;
    ind=ind+vec_in(j);
end
