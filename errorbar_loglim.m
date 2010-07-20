function[handle,handle2]=errorbar_loglim(x,y,ee,varargin)
hh=ishold;
assert(length(x)==length(y));
assert(length(x)==length(ee));
[e,str]=parseparams(varargin);
assert(length(e)<2);
if length(e)==1
    e=e{1};
else
    e=ee;
end
assert(length(x)==length(e));

if length(str)==1,
    cols=str{1};
else
    cols='+';
end
xrange=max(x)-min(x);
if xrange==0,
    xrange=1.0;
end
dx=0.01*xrange;
ytop=max(y+e);
vec=y-ee;
ybot=min(vec(vec>0));
yrange=log10(ytop/ybot);
if (yrange==0)
    yrange=2;
end

h2=plot(x,y,cols);
hold on;
xx=[];
yy=[];
for j=1:length(x),
    xplot=[];
    yplot=[];
    
    if y(j)>0,
        if y(j)-ee(j)>0,
            xplot=[x(j)-dx x(j)+dx x(j) x(j) x(j)-dx x(j)+dx nan];
            yplot=[y(j)+e(j) y(j)+e(j) y(j)+e(j) y(j)-ee(j) y(j)-ee(j) y(j)-ee(j) nan];
        else
            ybot=y(j)/(1+10^(0.1*yrange));
            yarrow=y(j)/(1+10^(0.05*yrange));
            xplot=[x(j)-dx   x(j)+dx   x(j)       x(j)       x(j)-dx nan x(j)+dx  x(j) nan];
            yplot=[y(j)+e(j) y(j)+e(j) y(j)+e(j)  ybot       yarrow    nan yarrow     ybot nan];                        
        end
    else
        if y(j)+e(j)>0,
            ybot=(y(j)+e(j))/(1+10^(0.1*yrange));
            yarrow=(y(j)+e(j))/(1+10^(0.05*yrange));

            xplot=[x(j)-dx   x(j)+dx   x(j)       x(j)       x(j)-dx nan x(j)+dx  x(j) nan];
            yplot=[y(j)+e(j) y(j)+e(j) y(j)+e(j)  ybot       yarrow    nan yarrow     ybot nan];                        
    
        end
    end
    xx=[xx xplot];
    yy=[yy yplot];
end
h=plot(xx,yy,get_color(cols));


if ~hh,
    hold off;
end

if (nargout>0)
    handle=h;
end
if (nargout>1)
    handle2=h2;
end


function[myc]=get_color(col)
if ~exist('col')
    myc='b';
    return;
end
if isletter(col(1))
    myc=col(1);
else
    myc='b';
end

