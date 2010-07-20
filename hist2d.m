function[mat,xx,yy]=hist2d(x,y,xbins,ybins)
assert(length(x)==length(y))
if ~exist('xbins')
    xbins=10;
end
if (~exist('ybins')),
    ybins=xbins;
end
if (ybins<1),
    frac=ybins/2;
    ybins=xbins;
else
    frac=0;
end



if frac>0,
    xsort=sort(x);
    xmin=xsort(ceil(frac*length(x)));
    xmax=xsort(floor((1-frac)*length(x)));
    ysort=sort(y);
    ymin=ysort(ceil(frac*length(y)));
    ymax=ysort(floor((1-frac)*length(y)));
else
    xmin=min(x);
    ymin=min(y);
    xmax=max(x);
    ymax=max(y);
end
disp([xmin xmax ymin ymax]);



xvals=ceil((x-xmin)/(xmax-xmin)*xbins);
xvals(xvals<1)=1;
xvals(xvals>xbins)=xbins;
yvals=ceil((y-ymin)/(ymax-ymin)*ybins);
yvals(yvals<1)=1;
yvals(yvals>ybins)=ybins;
mat(xbins,ybins)=0;
for j=1:length(x),
    mat(xvals(j),yvals(j))=mat(xvals(j),yvals(j))+1;
end

xx=xmin+(0.5+(1:xbins))*(xmax-xmin)/xbins;
yy=ymin+(0.5+(1:ybins))*(ymax-ymin)/ybins;

