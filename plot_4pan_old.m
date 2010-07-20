function[shifts,cent]=plot_4pan(names,shifts,cols,cent,thick)
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

if (nargin < 4)
    cent(:,1)=[  442.98       680.67        822.8       978.53         1116       1319.5         1819]';
    cent(:,2)=[  476.25       674.65       795.22       986.25       1120.3       1310.2       1698.8]';
    cent(:,3)=[ 482.14       673.52       795.95       989.06       1120.3       1310.8       1704.9]';
    cent(:,4)=[  462.91          681       814.37       979.74       1118.6       1316.4       1722.3]';
end

poltags=['TT'
'EE'
'BB'
'TE'];


cmb=load('wmap.cmb');
cmb(:,5)=0;
pol_map=[2 4 5 3];

for j=1:4,
    subplot(2,2,j)
    hold off 
    for k=1:nto_plot,
        col_use=sscanf(cols(k,:),'%s');
        [ls,col,mark,msg] = colstyle(col_use);
        name_use=sscanf(names(k,:),'%s');
        [dat,errs,ell,bands,which_pols,otherps,corrs]=read_newdat(name_use);
        if (size(cent,1)==bands(j))
            plot(cent(:,j)+shifts(k),dat(:,j),[col mark]);
        else
            plot(ell(1:bands(j),j)+shifts(k),dat(1:bands(j),j),[col mark]);
        end
        hold on
    end
    %plot(cmb(:,1),cmb(:,pol_map(j)),'m--');
    plot(cmb(:,1),cmb(:,pol_map(j)),'k');
    if ((j==2)|(j==4))
        plot(cmb(:,1),cmb(:,5),'k:');
    end
    for k=1:nto_plot,
        name_use=sscanf(names(k,:),'%s');
        [dat,errs,ell,bands,which_pols,otherps,corrs]=read_newdat(name_use);
        col_use=sscanf(cols(k,:),'%s');
        if (size(cent,1)==bands(j))
            errorbar_noline('v6',cent(:,j)+shifts(k),dat(:,j),errs(:,j),col_use);
        else
            errorbar_noline('v6',ell(1:bands(j),j)+shifts(k),dat(1:bands(j),j),errs(1:bands(j),j),col_use);
        end
    end
    xlabel(poltags(j,:));
    v=axis;
    v(1)=0;
    v(2)=2200;
    %if (j==2)
    %    v(3)=-150;
    %    v(4)=150;
    %end
    axis(v);
end
subplot(2,2,1);
