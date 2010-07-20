function[value]=plot_2D_param_set(chains,p1,p2,lab1,lab2)
lab_fontsize = 9; axes_fontsize = 9;
lineM = {'-k','-r','-b','-m','-g','-y'};
lineL = {':k',':r',':b',':m',':g',':y'};
lw1=1;lw2=1;

if (p1<p2)
    pp=p2;
    p2=p1;
    p1=pp;
    ll=lab1;
    lab1=lab2;
    lab2=ll;
end
%nmbase=fullfile('plot_data',[chains '_2D_' num2str(p1) '_' num2str(p2)]);
nmbase=[chains '_2D_' num2str(p1) '_' num2str(p2)];
pts=load(nmbase);
%tmp = load(fullfile('plot_data',[chains '_p' num2str(p2) '.dat']));
tmp = load([chains '_p' num2str(p2) '.dat']);
x1 = tmp(:,1);
%tmp = load(fullfile('plot_data',[chains '_p' num2str(p1) '.dat']));
tmp = load([chains '_p' num2str(p1) '.dat']);
x2 = tmp(:,1);
tocontour=load ([nmbase '_likes']);

contourf(x1,x2,tocontour,64);
set(gca,'climmode','manual'); shading flat; hold on;
cnt = load([nmbase '_cont']);
[C h] = contour(x1,x2,pts,cnt,lineM{1});
set(h,'LineWidth',lw1);
hold on; axis manual;
set(h,'LineWidth',lw2);
hold off; set(gca,'Layer','top','FontSize',axes_fontsize);
xlabel(lab2,'FontSize',lab_fontsize);
ylabel(lab1,'FontSize',lab_fontsize);
ls =get(gca,'XTick');sz=size(ls,2);
if(sz > 4)
    set(gca,'XTick',ls(:,1:2:sz));
end;