function[value]=get_samples_from_pdf(pdf_in,nsamp,x_in)
if (~exist('x_in'))
    x_in=1:length(pdf_in);
end
if (~exist('nsamp'))
    nsamp=1;
end

thresh=1e-15*sum(pdf_in(pdf_in>0));  %make sure we are big enough to perturb cumsum
pdf=pdf_in(pdf_in>thresh);
x=x_in(pdf_in>thresh);

pdf=pdf/sum(pdf); %make sure we're normalized

crud=0;
crud(2:1+length(pdf))=pdf;
pdf=crud;
crud=2*x(1)-x(2);
crud(2:1+length(x))=x;
x=crud;

value=interp1(cumsum(pdf),x,rand(nsamp,1));
