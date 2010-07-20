function[mat,upt,vpt,map_real]=visualize_vec(vec,u,v,oversamp)
%function[mat,upt,vpt]=visualize_vec(vec,u,v,du)

if (size(vec,2)>size(vec,1))
    vec=vec';
end

if (size(u,2)>size(u,1))
    u=u';
end
if (size(v,2)>size(v,1))
    v=v';
end


nelem=length(vec)/2;
real_vec=vec(1:2:(2*nelem-1));
imag_vec=vec(2:2:2*nelem);
u=u(1:nelem);
v=v(1:nelem);
u=[u' -u']';
v=[v' -v']';

[upt,whichu]=get_values(u);
[vpt,whichv]=get_values(v);
nu=max(size(upt));
nv=max(size(vpt));
mat(nu,nv)=0;

real_vec=[real_vec' real_vec']';
imag_vec=[imag_vec' imag_vec'*(-1)];
for j=1:max(size(u)),
    mat(whichu(j),whichv(j))=real_vec(j)+i*imag_vec(j);
end

if (nargout>=4)
    if (exist('oversamp'))
        map_real=fftshift(ifft2(ifftshift(pad_matrix(mat,oversamp))));
    else
        map_real=fftshift(ifft2(ifftshift(mat)));
    end
end
