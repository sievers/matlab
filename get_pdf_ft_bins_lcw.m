%function[x,pdf_cum,alpha_eff]=get_pdf_ft_bins(binvals,bincents,freq_ratio,flux_x,x)
function[flux_pdf,flux_pdf_ft,pdf,x]=get_pdf_ft_bins(binvals,bincents,freq_ratio,flux_x,x)

%get the Fourier transform of the 1-d PDF of the flux of a source given a
%spectral index distribution specified by a histogram.  Construct a spline
%of the alpha distribution given the pdf description, and have the pdf go
%to zero at one extra binwidth.

if length(binvals)~=length(bincents)
    error('Error - mismatch in length of bin values/centers in get_pdf_ft_bins');
end

binvals_use(2:length(binvals)+1)=binvals;
bincents_use(2:length(bincents)+1)=bincents;


nbin=length(binvals)+2;
binvals_use(1)=0;
binvals_use(nbin)=0;
bincents_use(1)=2*bincents_use(2)-bincents_use(3);
bincents_use(nbin)=2*bincents_use(nbin-1)-bincents_use(nbin-2);

if (nargin<5)
    x=0:1e4;
    x=x/max(x);
    nb=length(bincents_use);
    minval=2*bincents_use(1)-bincents_use(2);
    %maxval=2*bincents_use(nb)-bincents_use(nb-1);
    maxval=3*bincents_use(nb)-2*bincents_use(nb-1);
    
    %x=x*(max(bincents_use)-min(bincents_use))+min(bincents_use);
    x=x*(maxval-minval)+minval;

end

%pdf=spline(bincents_use,binvals_use,x);
pdf=interp1(bincents_use,binvals_use,x,'pchip',0);
%hold off;plot(x,pdf);

pdf(x<min(bincents_use))=0;
pdf(x>max(bincents_use))=0;
pdf(pdf<0)=0;

%hold off;
%plot(x,pdf/max(pdf)*max(binvals_use),'r');
%hold on;
%plot(bincents_use,binvals_use,'+-');

%OK - now we have a cleaned, interpolated alpha distribution.  Now turn it
%into a distribution on fluxes.  Do this by taking apropriate power of the
%alpha value, weight by the pdf, and do a sum

%on second thought, transform the flux into an index, then the integral
%should be easier to carry out.

flux_x(flux_x<=0)=1e-12; %avoid singularities
alpha_eff=log(flux_x)/log(freq_ratio);
flux_pdf=0*flux_x;

x_targ=ceil( (alpha_eff-min(x))/(max(x)-min(x))*length(x));
x_targ(x_targ<1)=1;
x_targ(x_targ>length(x))=length(x);
%hold off;plot(x_targ,'.');
pdf_cum=cumsum(pdf);

crap=interp1(x,pdf_cum,alpha_eff);

nx=length(flux_x);
flux_pdf=0*flux_x;
flux_pdf(2:nx)=crap(2:nx)-crap(1:nx-1);
flux_pdf(isnan(flux_pdf))=0;

%[sum(flux_pdf) sum(pdf)]
if(sum(flux_pdf > 0))
    flux_pdf=flux_pdf/sum(flux_pdf);
else
    flux_pdf=ones(1,length(flux_x))/length(flux_x);
end
%flux_pdf=flux_pdf/sum(flux_pdf(isreal(flux_pdf)));
flux_pdf_ft=fft(flux_pdf);