function[value]=gadged_kernel(r)  
%return the gadget kernel for r, the distance from the particle center
%divided by the smoothing length.

r=abs(r);
value=0*r;
ind=r<1;
value(ind)=2*(1-r(ind)).^3;
ind=r<0.5;
value(ind)=1-6*(r(ind).^2)+6*(r(ind).^3);
