function[single_c]=get_one_contour(c,which_cont)
start_val=0;
for j=1:(which_cont-1),
    nelem=c(2,start_val+1);
    start_val=start_val+nelem+1;
end
nelem=c(2,start_val+1);
single_c=c(:,(start_val+2):(start_val+1+nelem));
