%load HubblenCIIa30
load HubblenCIII\30;hubblenCIIa=hubblenCIII;
%load HubblenCIIb30;hubblenCIIa=hubblenCIIb;


hvec=(0:1000)/1000*240;
smooth=1.0;

smooth_vec=exp(-0.5*hvec.^2/smooth^2);
smooth_vec(2:end)=smooth_vec(2:end)+fliplr(smooth_vec(2:end));
smooth_vec=smooth_vec/sum(smooth_vec);

nbh=size(hubblenCIIa,1);
hist_smooth=0*hubblenCIIa;
for j=1:nbh,
    hist_smooth(j,:)=ifft(fft(hubblenCIIa(j,:)).*fft(smooth_vec)).*hvec.^2;    
end

htot=ones(size(smooth_vec));
for j=1:nbh,
    htot=htot.*hist_smooth(j,:);
end
vec=real(fft(smooth_vec));
vec(vec<1e-2*max(vec))=1e-4*max(vec);

htot_unsmooth=ifft(fft(htot)./vec);

hmean=sum(htot.*hvec)/sum(htot);
hvar=sum(htot.*hvec.^2)/sum(htot);
hscat=sqrt(hvar-hmean^2-smooth^2/nbh);
disp(['mean of h0 is ' num2str(hmean)]);
disp(['standard error on mean is ' num2str(hscat)]);
hist_plot=hist_smooth;
for j=1:nbh,
    hist_plot(j,:)=hist_plot(j,:)/sum(hist_plot(j,:));
end
htot_plot=htot/sum(htot);
clf;
plot(hvec,hist_plot);
hold on;
hand=plot(hvec,htot_plot);
set(hand,'LineWidth',3);
hold off;

