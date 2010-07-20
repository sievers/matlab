function[emat,bmat,upt,vpt,rl]=visualize_pol(data,u,v,dorot)
if (nargin<4)
    dorot=0;
end


if (dorot>=0)
    n=max(size(data));
    n=n/3;
    ncell=n/2;
    data_use=data((n+1):(3*n));
    u_use=u((ncell+1):3*ncell);
    v_use=v((ncell+1):3*ncell);
else
    n=max(size(data));
    n=n/2;
    ncell=n/2;
    data_use=data;
    u_use=u;
    v_use=v;
end

%figure(1);imagesc(u_use);
%figure(2);imagesc(v_use);
if (dorot)
    theta=pi/4+atan2(u_use,v_use);
    phase=exp(-2*theta*i);
    for j=1:ncell,
        data_temp=data_use(2*j-1)+i*data_use(2*j);
        data_temp=phase(j)*data_temp;
        data_use(2*j-1)=real(data_temp);
        data_use(2*j)=imag(data_temp);
    end
end



[upt,whichu]=get_values(u_use);
[vpt,whichv]=get_values(v_use);
nu=max(size(upt));
nv=max(size(vpt));
rl(nu,nv)=0;
for j=1:ncell*2,
    rl(whichu(j),whichv(j))=data_use(2*j-1)+i*data_use(2*j);    
end

for j=1:nu,
    for k=1:nv,
        lr(j,k)=conj(rl(nu+1-j,nv+1-k));
    end
end
emat(nu,nv)=0;
bmat(nu,nv)=0;
for j=1:nu,
    for k=1:nv,
        emat(j,k)=0.5*(lr(j,k)+rl(j,k));
        bmat(j,k)=0.5*(rl(j,k)-lr(j,k))/i;
    end
end

