function[ticks]=do_raaxis_labels(h)
if (nargin<1)
    h=gca;
end


ralims=get(h,'XLim');
ralims=60*ralims;
ramin=ceil(min(ralims));
ramax=floor(max(ralims));
dra=round((ramax-ramin)/5);

ticks=(ramin:dra:ramax)/60;

set(h,'XTickMode','manual','XTick',ticks);
ntick=length(ticks);
for j=1:ntick
    fwee=get_rastring(ticks(j));
    labs(j,1:length(fwee))=fwee;
end
set(h,'XTickLabelMode','manual','XTickLabel',labs);
