function[shifts,cent]=plot_4pan(names,shifts,cols,cent)
nto_plot=size(names,1);

if ((nargin<2)|(isempty(shifts)))
    shifts_old=50;
    shifts=0;
else
    if (max(size(shifts))==1)
        shifts_old=shifts;
    end
end
if (max(size(shifts))==1)
    if (nto_plot>1)
        shifts=(0:(nto_plot)-1)/(nto_plot-1);
        shifts=shifts/(max(shifts)-min(shifts));
        shifts=shifts-mean(shifts);
        shifts=shifts*shifts_old;  %+/-40 from the center;
    end
  
end
if (nargin<3)
    cols=['bo'
        'ro'
        'go'
        'co'
        'mo'
        'yo'];
    ncol=size(cols,1);
    if (nto_plot>ncol),
        for j=(ncol+1):nto_plot,
            cols(j,:)=cols(j-ncol,:);
        end
    end
end

%if (nargin < 4)
%    cent(:,1)=[  442.98       680.67        822.8       978.53         1116       1319.5         1819]';
%end

poltags=['TT'];


cmb=load('/cita/d/raid-sievers/sievers/wmap.cmb');

hold off 
for k=1:nto_plot,
    col_use=sscanf(cols(k,:),'%s');
    [ls,col,mark,msg] = colstyle(col_use);
    name_use=sscanf(names(k,:),'%s');
    [dat,errs,ell,bands,which_pols,otherps,corrs]=read_newdat(name_use);
    if (nargin<4)
        cent=ell;
    end
    plot(cent(:,1)+shifts(k),dat(:,1),[col mark]);
    hold on
end
%plot(cmb(:,1),cmb(:,pol_map(j)),'m--');
plot(cmb(:,1),cmb(:,2),'k');
plot(cmb(:,1),0*cmb(:,2),'k--');
for k=1:nto_plot,
    name_use=sscanf(names(k,:),'%s');
    [dat,errs,ell,bands,which_pols,otherps,corrs]=read_newdat(name_use);
    col_use=sscanf(cols(k,:),'%s');
    errorbar_noline('v6',cent(:,1)+shifts(k),dat(:,1),errs(:,1),col_use);
end
v=axis;
v(1)=0;
v(2)=3000;
axis(v);
end
