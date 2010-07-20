function[data]=plot_2D_param_set(chains,lab1,lab2)
[lab1,p1]=cosmomc_labs(lab1);
[lab2,p2]=cosmomc_labs(lab2);

if (p1<p2)
    pp=p2;
    p2=p1;
    p1=pp;
    ll=lab1;
    lab1=lab2;
    lab2=ll;
end
nmbase=[chains '_2D_' num2str(p1) '_' num2str(p2)];
pts=load(nmbase);
tmp = load([chains '_p' num2str(p2) '.dat']);
x1 = tmp(:,1);
tmp = load([chains '_p' num2str(p1) '.dat']);
x2 = tmp(:,1);
tocontour=load ([nmbase '_likes']);

cnt = load([nmbase '_cont']);

data.x=x1;
data.y=x2;
data.like=tocontour;
data.cont=pts;
data.levels=cnt;
