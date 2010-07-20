function[mat,mat2,big_mat,cmb_sig]=make_shape_tt_signal_mat_fast(rgrid,u,v,du,zdump,shape,lmin,lmax,conjstat,cmb_sig_only)
if (length(shape)<lmax)
    shape(round(lmax))=0;
end

shape(length(shape)+1:8000)=shape(length(shape));


if (nargin<9)
    conjstat=0;
end




maxu=max([max(abs(u)) max(abs(v))]);

nbeam=size(rgrid,1);
pad=(size(rgrid,1)-1)/2;

cmbvec=((-maxu-pad):(maxu+pad));
ncmb=length(cmbvec);
cmb_r=repmat(cmbvec.^2,[ncmb 1]);
cmb_r=2*pi*du*sqrt(cmb_r+cmb_r');
cmb_r=floor(cmb_r);
cmb_r(maxu+pad+1,maxu+pad+1)=1;




%whos cmb_r
%plot(cmb_r(:,round(ncmb/2)))
cmb_sig=0*cmb_r;
%cmb_sig(cmb_r>=lmin)=1;
%cmb_sig(cmb_r>lmax)=0;
%cmb_sig=cmb_sig./(cmb_r.^2);
a=du/sqrt(pi)*2*pi;
for j=1:size(cmb_r,1),
    for k=1:size(cmb_r,2),
        cmb_sig(j,k)=shape(floor(cmb_r(j,k)))*(cell_area(a,lmax,cmb_r(j,k))-cell_area(a,lmin,cmb_r(j,k)))/4/pi^2;
    end
end
cmb_sig(maxu+pad+1,maxu+pad+1)=0;
cmb_sig=2*pi*cmb_sig./(cmb_r.^2);
if (nargin<10)
    cmb_sig_only=0;
end

if (cmb_sig_only)
    %cmb_sig=cmb_r;
    mat=cmb_sig;
    return
end



%imagesc(cmb_sig)


nest=length(u);
mat(nest,nest)=0;
mat_conj(nest,nest)=0;

estgrid_u=u+maxu+pad;
estgrid_v=v+maxu+pad;

%for j=1:nest,
%    for k=j:nest,
%        d=sqrt( (u(j)-u(k))^2+(v(j)-v(k))^2);
%        if (d<2*pad)
%            mat(j,k)=1;
%            mat(k,j)=1;
%        end
%    end
%end

%for j=1:nest,
%    for k=j:nest,        
%        d=sqrt( (u(j)+u(k))^2+(v(j)+v(k))^2);
%        if (d<2*pad)
%            mat(j,k)=1;
%            mat(k,j)=1;
%        end
%    end
%end
mat(nest,nest)=0;

diagvec(nest,1)=0;
padvec=-pad:pad;
%whos cmb_sig
for j=1:nest,
    %disp([j u(j) v(j)])   
    diagvec(j)=sum(sum(rgrid(:,:,j).*conj(rgrid(:,:,j)).*cmb_sig(u(j)+maxu+pad+padvec+1,v(j)+maxu+pad+padvec+1)));
end
a=now;
mat=0*mat;
mat2=mat;
%nest=3;

for j=nest:-1:1,
    ulow_cmb=u(j)-pad+maxu+pad+1;
    uhigh_cmb=u(j)+pad+maxu+pad+1;
    vlow_cmb=v(j)-pad+maxu+pad+1;
    vhigh_cmb=v(j)+pad+maxu+pad+1;    
    ind(j,1)=sum(sum(abs(rgrid(:,:,j)).*abs(cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb))));
end
vec=(1:nest)';
ind=vec(ind>0);
clear vec;
nuse=length(ind);
for j=1:nuse,    
    for k=j:nuse,
        du=u(ind(j))-u(ind(k));
        dv=v(ind(j))-v(ind(k));
        duv=sqrt(du^2+dv^2);
        %if ((abs(u(j)-u(k))<=2*pad)&(abs(v(j)-v(k))<=2*pad))
        if (duv<=nbeam)

            delta_u=u(ind(k))-u(ind(j));
            delta_v=v(ind(k))-v(ind(j));

            if (delta_u>0)
                ulow_j=1+delta_u;
                ulow_k=1;
                uhigh_j=2*pad+1;
                uhigh_k=2*pad+1-delta_u;
            else
                ulow_j=1;
                ulow_k=1-delta_u;
                uhigh_j=2*pad+1+delta_u;
                uhigh_k=2*pad+1;
            end

            if (delta_v>0)
                vlow_j=1+delta_v;
                vlow_k=1;
                vhigh_j=2*pad+1;
                vhigh_k=2*pad+1-delta_v;
            else
                vlow_j=1;
                vlow_k=1-delta_v;
                vhigh_j=2*pad+1+delta_v;
                vhigh_k=2*pad+1;
            end
                        
            umin=min([u(ind(j)) u(ind(k))]);
            umax=max([u(ind(j)) u(ind(k))]);
            vmin=min([v(ind(j)) v(ind(k))]);
            vmax=max([v(ind(j)) v(ind(k))]);
            ulow_cmb=umax-pad+maxu+pad+1;
            uhigh_cmb=umin+pad+maxu+pad+1;
            vlow_cmb=vmax-pad+maxu+pad+1;
            vhigh_cmb=vmin+pad+maxu+pad+1;
            mat(ind(j),ind(k))=sum(sum(rgrid(ulow_j:uhigh_j,vlow_j:vhigh_j,ind(j)).*conj(rgrid(ulow_k:uhigh_k,vlow_k:vhigh_k,ind(k))).*cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb)))/zdump(ind(j))/zdump(ind(k));

            %mat2(j,k)=sum(sum(rgrid(ulow_j:uhigh_j,vlow_j:vhigh_j,j).*(rgrid(ulow_k:uhigh_k,vlow_k:vhigh_k,k)).*cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb)))/zdump(j)/zdump(k);

            mat(ind(k),ind(j))=conj(mat(ind(j),ind(k)));

            %mat(j,k)=1;
%            disp([j k]);
%            disp([u(j) v(j) u(k) v(k)]);
%            disp([ulow_j uhigh_j ulow_k uhigh_k ulow_cmb uhigh_cmb]);
%            disp([vlow_j vhigh_j vlow_k vhigh_k vlow_cmb vhigh_cmb]);
        end
    end
end


for j=1:nuse,    
    %u(j)=-1*u(j);
    %v(j)=-1*v(j);
    %rgrid(:,:,j)=flipud(fliplr(rgrid(:,:,j)));
    uj=-1*u(ind(j));
    vj=-1*v(ind(j));
    rgridj=flipud(fliplr(rgrid(:,:,ind(j))));
    for k=j:nuse,
        du=uj-u(ind(k));
        dv=vj-v(ind(k));
        duv=sqrt(du^2+dv^2);
        %if ((abs(u(j)-u(k))<=2*pad)&(abs(v(j)-v(k))<=2*pad))

        
        if (duv<=nbeam)
            delta_u=u(ind(k))-uj;
            delta_v=v(ind(k))-vj;

            if (delta_u>0)
                ulow_j=1+delta_u;
                ulow_k=1;
                uhigh_j=2*pad+1;
                uhigh_k=2*pad+1-delta_u;
            else
                ulow_j=1;
                ulow_k=1-delta_u;
                uhigh_j=2*pad+1+delta_u;
                uhigh_k=2*pad+1;
            end

            if (delta_v>0)
                vlow_j=1+delta_v;
                vlow_k=1;
                vhigh_j=2*pad+1;
                vhigh_k=2*pad+1-delta_v;
            else
                vlow_j=1;
                vlow_k=1-delta_v;
                vhigh_j=2*pad+1+delta_v;
                vhigh_k=2*pad+1;
            end
                        
            umin=min([uj u(ind(k))]);
            umax=max([uj u(ind(k))]);
            vmin=min([vj v(ind(k))]);
            vmax=max([vj v(ind(k))]);
            
            i_u_min = max([1,1+delta_u]);
            i_v_min = max([1 1+delta_v]);
            i_u_max = min([nbeam nbeam+delta_u]);
            i_v_max = min([nbeam nbeam+delta_v]);
            
            
            ulow_cmb=umax-pad+maxu+pad+1;
            uhigh_cmb=umin+pad+maxu+pad+1;
            vlow_cmb=vmax-pad+maxu+pad+1;
            vhigh_cmb=vmin+pad+maxu+pad+1;
            mat2(ind(j),ind(k))=sum(sum(rgridj(ulow_j:uhigh_j,vlow_j:vhigh_j).*(rgrid(ulow_k:uhigh_k,vlow_k:vhigh_k,ind(k))).*cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb)))/zdump(ind(j))/zdump(ind(k));
            mat2(ind(k),ind(j))=(mat2(ind(j),ind(k)));
            %mat(j,k)=1;
%            disp([j k]);
%            disp([u(j) v(j) u(k) v(k)]);
%            disp([ulow_j uhigh_j ulow_k uhigh_k ulow_cmb uhigh_cmb]);
%            disp([vlow_j vhigh_j vlow_k vhigh_k vlow_cmb vhigh_cmb]);
        end
    end
end

b=now;
disp(86400*(b-a));


clear big_mat;
if (conjstat>0)
    mat2=0*mat2;
end
if (conjstat<0)
    mat=0*mat;
end

if ((nargout==1)|(nargout>2))
    big_mat(2:2:2*nest,2:2:2*nest)=real(mat-mat2);
    big_mat(1:2:2*nest,1:2:2*nest)=real(mat+mat2);
    big_mat(1:2:2*nest,2:2:2*nest)=imag(-mat+mat2);
    big_mat(2:2:2*nest,1:2:2*nest)=-imag(-mat-mat2);
    big_mat=0.5*big_mat;
end
if (nargout==1)
    clear mat;
    clear mat2;
    
    mat=big_mat;
end


