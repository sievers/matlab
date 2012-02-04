function[mat_inv]=inverse_semiprojected_diag(mat_to_inv,proj_mat);
%use sherman-woodbury to invert a symmetric matrix with bits added
%input matrix is assumed to be diagonal



if size(proj_mat,1)<size(proj_mat,2),
    proj_mat=proj_mat';
end

if size(mat_to_inv,1)==size(mat_to_inv,2)
  mm=diag(mat_to_inv);
  assert(sum(abs(mm))==sum(sum(abs(mat_to_inv))));
  mat_to_inv=mm;
end

vm=proj_mat;
for j=1:size(vm,2),
  vm(:,j)=vm(:,j)./mat_to_inv;
end
inside=proj_mat'*vm;
inside_inv=inv(eye(length(inside))+inside);
mat_inv=diag(1./mat_to_inv);
mat_inv=mat_inv-vm*(inside_inv*vm');
