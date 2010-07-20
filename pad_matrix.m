function[bigmat]=pad_matrix(mat,fac)
nx=size(mat,1);
ny=size(mat,2);
bigmat((2*fac+1)*nx,(2*fac+1)*ny)=0;
bigmat( (fac*nx+1):((fac+1)*nx),(fac*ny+1):((fac+1)*ny))=mat;

