function[mat_inv]=inverse_projected(mat_to_inv,proj_mat,do_qr);

mat_inv=inv(mat_to_inv);
if size(proj_mat,1)<size(proj_mat,2),
    proj_mat=proj_mat';
end

%small_mat=invsafe(proj_mat'*mat_inv*proj_mat,-1e-12);
small_mat=inv(proj_mat'*mat_inv*proj_mat);

%return;

%mat_inv=mat_inv-(mat_inv*proj_mat)*small_mat*(proj_mat'*mat_inv);

fwee=proj_mat'*mat_inv;
mat_inv=mat_inv-fwee'*small_mat*fwee;
%mat_inv=mat_inv-mat_inv*((proj_mat*small_mat*proj_mat'))*mat_inv;
