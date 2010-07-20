function[c,h,line_h]=plot_contours_cosmomc(varargin)
if (iscell(varargin{1}))
    crud=varargin{1};
    if size(crud,1)>1
        crud=crud';
    end
    varargin=[crud varargin(2:length(varargin))];
end

for j=length(varargin):-1:1,
    which_mats(j)=isstruct(varargin{j});
end
nmat=sum(which_mats);
mats=varargin(which_mats);
varargin=varargin(~which_mats);
if length(varargin)==0
    cols =[0 0 1
        1 0 0
        0 1 0
        0.5 0.5 0.5];
end
if length(varargin)==1
    cols=varargin{1};
end

hold off;
for j=1:nmat,
    dat=mats{j};
    [c_in,h(j)]=contourf(dat.x,dat.y,dat.cont,dat.levels);
    hold on;
    hh=get(h(j),'Children');
    nconts(j)=length(dat.levels);
    ind=1:nconts(j);
    for k=1:length(hh),
        which_ind=ind(get(hh(k),'CData')==dat.levels);
        set(hh(k),'FaceColor',cols(j,:)*(which_ind/nconts(j)));
    end
    c{j}=c_in;
end
%now do the lines
for j=1:nmat,
    hh=get(h(j),'Children');
    ncont=length(hh);
    cc=c{j};
    ind=1:nconts(j);

    for k=1:ncont,
        which_ind=ind(get(hh(k),'CData')==dat.levels);

        ccc=cc(:,2:cc(2,1));
        cc=cc(:,(2+cc(2,1)):size(cc,2));
        hvec(j)=plot(ccc(1,:),ccc(2,:),'--');
        col=get(hh(k),'FaceColor');
        set(hvec(j),'Color',col,'LineWidth',2');
    end
    line_h{j}=hvec;
end
if (nargout==0)
    clear c;
end
