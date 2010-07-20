function[mat]=put_matrix_in_center(mat_small,mat_targ)
mat=0*mat_targ;
x1=ceil(size(mat_small,1)/2);
x2=ceil(size(mat_targ,1)/2);

y1=ceil(size(mat_small,2)/2);
y2=ceil(size(mat_targ,2)/2);

xx=x2+ (1:size(mat_small,1))-x1;
yy=y2+ (1:size(mat_small,2))-y1;
mat(xx,yy)=mat_small;
