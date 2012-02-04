function[value]=apply_inverse_semiprojected_diag(data,mat_to_inv,proj_mat);
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


minv=1./mat_to_inv;

mm=repmat(minv,[1 size(data,2)]);


ninvd=data.*mm;

%for j=1:size(data,2),
%  ninvd(:,j)=ninvd(:,j).*minv;
%end

if (1)
  m2=repmat(minv,[1 size(proj_mat,2)]);
  vm=m2.*proj_mat;
  clear m2;
else
  vm=proj_mat;
  for j=1:size(vm,2),
      vm(:,j)=vm(:,j).*minv;
  end
end



inside=proj_mat'*vm;
inside_inv=inv(eye(length(inside))+inside);

crud=proj_mat*(inside_inv*proj_mat'*ninvd);
%for j=1:size(crud,2),
%  crud(:,j)=crud(:,j).*minv;
%end
crud=crud.*mm;
value=ninvd-crud;
