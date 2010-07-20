function[value]=get_savgol_coeffs_alldata(dx,order)
%get savitsky-golay filter coefficients for a region of size +/- dx, and 
%polynomial order order

a(2*dx+1,order+1)=0;
for j=1:2*dx+1,
  for k=1:order+1,
    a(j,k)=(j-dx-1)^(k-1);
  end
end

siginv=eye(2*dx+1);
%set the weight of the central pixel equal to zero, so a 
%cosmic ray won't thow off its own fit
%siginv(dx+1,dx+1)=0; 
%siginv(dx+2,dx+2)=0; 
%siginv(dx+0,dx+0)=0; 


mat_inv=inv(a'*siginv*a);
value=mat_inv*a'*siginv;
