function[mattrim]=uvtrim(mat,thresh,u,v,thresh2)
mattrim=mat;
nu=size(mat,1);
nv=size(mat,2);
thresh=thresh*thresh;

for j=1:nu,
    for k=1:nv,
        if (u(j)*u(j)+v(k)*v(k)>thresh)
            mattrim(j,k)=0;
        end
    end
end

if (nargin>4)
    thresh2=thresh2*thresh2;
    for j=1:nu,
        for k=1:nv,
            if (u(j)*u(j)+v(k)*v(k)<thresh2)
                mattrim(j,k)=0;
            end
        end
    end
end

   