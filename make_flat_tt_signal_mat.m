function[big_mat,mat,mat2,diagvec]=make_flat_tt_signal_mat(rgrid,u,v,du,zdump,lmin,lmax)


maxu=max([max(abs(u)) max(abs(v))])
pad=(size(rgrid,1)-1)/2

cmbvec=((-maxu-pad):(maxu+pad));
ncmb=length(cmbvec);
cmb_r=repmat(cmbvec.^2,[ncmb 1]);
cmb_r=2*pi*du*sqrt(cmb_r+cmb_r');

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
        cmb_sig(j,k)=(cell_area(a,lmax,cmb_r(j,k))-cell_area(a,lmin,cmb_r(j,k)))/4/pi^2;
    end
end
cmb_sig(maxu+pad+1,maxu+pad+1)=0;
cmb_sig=2*pi*cmb_sig./(cmb_r.^2);

%big_mat=cmb_sig;
%return


%imagesc(cmb_sig)


nest=length(u);
mat(nest,nest)=0;
mat_conj(nest,nest)=0;

estgrid_u=u+maxu+pad;
estgrid_v=v+maxu+pad;

for j=1:nest,
    for k=j:nest,
        %d=sqrt( (estgrid_u(j)-estgrid_u(k))^2+(estgrid_v(j)-estgrid_v(k))^2);
        d=sqrt( (u(j)-u(k))^2+(v(j)-v(k))^2);
        %if((abs(estgrid_u(j)-estgrid_u(k))<=pad)&(abs(estgrid_v(j)-estgrid_v(k))<=pad))
        if (d<2*pad)
            mat(j,k)=1;
            mat(k,j)=1;
        end
    end
end

for j=1:nest,
    for k=j:nest,        
        %d=sqrt( (estgrid_u(j)+estgrid_u(k))^2+(estgrid_v(j)+estgrid_v(k))^2);
        d=sqrt( (u(j)+u(k))^2+(v(j)+v(k))^2);
        %if
        %((abs(estgrid_u(j)+estgrid_u(k))<=pad)&(abs(estgrid_v(j)+estgrid_v(k))<=pad))
        if (d<2*pad)
            mat(j,k)=1;
            mat(k,j)=1;
        end
    end
end


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
for j=1:nest,    
    for k=j:nest,
        if ((abs(u(j)-u(k))<=2*pad)&(abs(v(j)-v(k))<=2*pad))
            delta_u=u(k)-u(j);
            delta_v=v(k)-v(j);

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
                        
            umin=min([u(j) u(k)]);
            umax=max([u(j) u(k)]);
            vmin=min([v(j) v(k)]);
            vmax=max([v(j) v(k)]);
            ulow_cmb=umax-pad+maxu+pad+1;
            uhigh_cmb=umin+pad+maxu+pad+1;
            vlow_cmb=vmax-pad+maxu+pad+1;
            vhigh_cmb=vmin+pad+maxu+pad+1;
            mat(j,k)=sum(sum(rgrid(ulow_j:uhigh_j,vlow_j:vhigh_j,j).*conj(rgrid(ulow_k:uhigh_k,vlow_k:vhigh_k,k)).*cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb)))/zdump(j)/zdump(k);
            mat(k,j)=conj(mat(j,k));

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


for j=1:nest-1,    
    u(j)=-1*u(j);
    v(j)=-1*v(j);
    rgrid(:,:,j)=flipud(fliplr(rgrid(:,:,j)));
    for k=j+1:nest,
        if ((abs(u(j)-u(k))<=2*pad)&(abs(v(j)-v(k))<=2*pad))
            delta_u=u(k)-u(j);
            delta_v=v(k)-v(j);

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
                        
            umin=min([u(j) u(k)]);
            umax=max([u(j) u(k)]);
            vmin=min([v(j) v(k)]);
            vmax=max([v(j) v(k)]);
            ulow_cmb=umax-pad+maxu+pad+1;
            uhigh_cmb=umin+pad+maxu+pad+1;
            vlow_cmb=vmax-pad+maxu+pad+1;
            vhigh_cmb=vmin+pad+maxu+pad+1;
            mat2(j,k)=sum(sum(rgrid(ulow_j:uhigh_j,vlow_j:vhigh_j,j).*(rgrid(ulow_k:uhigh_k,vlow_k:vhigh_k,k)).*cmb_sig(ulow_cmb:uhigh_cmb,vlow_cmb:vhigh_cmb)))/zdump(j)/zdump(k);
            mat2(k,j)=(mat2(j,k));
            %mat(j,k)=1;
%            disp([j k]);
%            disp([u(j) v(j) u(k) v(k)]);
%            disp([ulow_j uhigh_j ulow_k uhigh_k ulow_cmb uhigh_cmb]);
%            disp([vlow_j vhigh_j vlow_k vhigh_k vlow_cmb vhigh_cmb]);
        end
    end
end

clear big_mat;
big_mat(2:2:2*nest,2:2:2*nest)=real(mat-mat2);
big_mat(1:2:2*nest,1:2:2*nest)=real(mat+mat2);
big_mat(1:2:2*nest,2:2:2*nest)=imag(-mat+mat2);
big_mat(2:2:2*nest,1:2:2*nest)=-imag(-mat-mat2);
big_mat=0.5*big_mat;

