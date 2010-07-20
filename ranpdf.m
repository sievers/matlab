function[vals]=ranpdf(n,x,pdf)
%generate random deviates from a generic, tabulated PDF.  x is the set of
%points over which the pdf is defined, and pdf is the value there.
ranvec=rand(n);
pdf_cum=cumsum(pdf/sum(pdf));
crud=1:length(pdf_cum);
crud=crud/length(pdf_cum)/pdf_cum(length(pdf_cum))/1e12;

ind=1:length(x);
minval=min(ind(pdf_cum>0));
if minval>1
    minval=minval-1;
end

maxval=max(ind(pdf_cum<(1-1e-13)));
if maxval<length(x)
    maxval=maxval+1;
end


pdf_cum_use=pdf_cum(minval:maxval)+crud(minval:maxval);
x_use=x(minval:maxval);
%ranvec=sort(ranvec);
vals=interp1(pdf_cum_use,x_use,ranvec);
