function[c,h,line_h]=plot_contours_cosmomc(varargin)
if (min(size(varargin{1}))==1)
    x=varargin{1};
    y=varargin{2};
    varargin=varargin(3:max(size(varargin)));
else
    x=1:size(varargin{1},2);
    y=1:size(varargin{1},1);
end

nelem=length(varargin);
if iseven(nelem)
    cols =[0 0 1
        1 0 0
        0 1 0
        0.5 0.5 0.5];
    nmat=nelem/2;
else
    cols=varargin{nelem};
    varargin=varargin(1:(nelem-1));
    nmat=(nelem-1)/2;
end
big_mat(max(size(y)),max(size(x)),nmat)=0;

for j=1:nmat,
    big_mat(:,:,j)=varargin{2*j-1};
    big_conts{j}=varargin{2*j};
    nconts(j)=length(big_conts{j});
end

%if (size(varargin{nmat})~=size(varargin{1}))
%    cols_bot=varargin{nmat};
%    varargin=varargin(1:nmat-1);
%    nmat=nmat-1;
%else
%    cols_bot=0*cols;
%end


hold off;
for j=1:nmat,
    [c_in,h(j)]=contourf(x,y,big_mat(:,:,j),big_conts{j});
    hold on;
    hh=get(h(j),'Children');
    for k=1:length(hh),
        set(hh(k),'FaceColor',cols(j,:)*(k/nconts(j)));
    end
    c{j}=c_in;
end

%now do the lines
for j=1:nmat,
    hh=get(h(j),'Children');
    ncont=length(hh);
    cc=c{j};
    for k=1:ncont,
        ccc=cc(:,2:cc(2,1));
        cc=cc(:,(2+cc(2,1)):size(cc,2));
        hvec(j)=plot(ccc(1,:),ccc(2,:),'--');
        col=get(hh(k),'FaceColor');
        set(hvec(j),'Color',col,'LineWidth',2');
    end
    line_h{j}=hvec;
end

