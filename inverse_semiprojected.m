function[mat_inv]=inverse_semiprojected(mat_to_inv,proj_mat);
%use sherman-woodbury to invert a symmetric matrix with bits added

if size(proj_mat,1)<size(proj_mat,2),
    proj_mat=proj_mat';
end


mat_inv=inv(mat_to_inv);

inside=proj_mat'*mat_inv*proj_mat;
inside_inv=inv(inside+eye(length(inside)));
mm=proj_mat'*mat_inv;
mat_inv=mat_inv-mm'*(inside_inv*mm);

