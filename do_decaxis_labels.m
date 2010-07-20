function[ticks,labs]=do_decaxis_labels(h)
if (nargin<1)
    h=gca;
end


declims=get(h,'YLim');
decmin=ceil(min(declims));
decmax=floor(max(declims));
ddec=round(decmax-decmin)/5;

ticks=(decmin:ddec:decmax);

set(h,'YTickMode','manual','YTick',ticks);
ntick=length(ticks);
for j=1:ntick
    fwee=get_decstring(ticks(j));
    labs(j,1:length(fwee))=fwee;
end
set(h,'YTickLabelMode','manual','YTickLabel',labs);
