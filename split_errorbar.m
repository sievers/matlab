function[plot_hand]=split_errorbar(h,varargin)
  fwee=get(h(1),'YLimMode');
doy1hold=0;
if (fwee(1)=='m')
  doy1hold=1;
y1lim=get(h(1),'YLim');
end

fwee=get(h(2),'YLimMode');
doy2hold=0;
if (fwee(1)=='m')
  doy2hold=1;
y2lim=get(h(2),'YLim');
end

fwee=get(h(1),'XLimMode');
dox1hold=0;
if (fwee(1)=='m')
  dox1hold=1;
x1lim=get(h(1),'XLim');
end

fwee=get(h(2),'XLimMode');
dox2hold=0;
if (fwee(1)=='m')
  dox2hold=1;
x2lim=get(h(2),'XLim');
end


axes(h(1));
fwee=get(h(1),'XScale');
if (fwee(2)=='o') %log
    h1=errorbar_log(varargin{:});
else
    h1=errorbar_scale(varargin{:});
end

axes(h(2));
fwee=get(h(2),'XScale');
if (fwee(2)=='o') %log
    h2=errorbar_log(varargin{:});
else
    h2=errorbar_scale(varargin{:});
end


if (nargout>0)
  plot_hand=[h1; h2];
end



if (doy1hold)
  set(h(1),'YLimMode','manual');
set(h(1),'YLim',y1lim);
end

if (doy2hold)
  set(h(2),'YLimMode','manual');
set(h(2),'YLim',y2lim);
end

if (dox1hold)
  set(h(1),'XLimMode','manual');
set(h(1),'XLim',x1lim);
end

if (dox2hold)
  set(h(2),'XLimMode','manual');
set(h(2),'XLim',x2lim);
end
if (h(3)==1)
  set(h(2),'YAxisLocation','right');
 else
   set(h(2),'XAxisLocation','top');
end
