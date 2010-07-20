function[value]=double_vec(vec)
%make a double-lengthed copy of the input.  so [1 2 3 ] -> [1 1 2 2 3 3]
if size(vec,1)==1,
    do_flip=false;
else
    vec=vec';
    do_flip=true;
end
vec=[vec;vec];
value=reshape(vec,[1 numel(vec)]);
if (do_flip)
    value=value';
end

