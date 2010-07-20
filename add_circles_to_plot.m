function[value]=add_circles_to_plot(points,fwhm,col)
if (nargin<3)
    col='m--';
end
if (nargin<2)
    fwhm=44;
end
rad=fwhm/2/60;  %convert fwhm in arcmin to radius in degrees
dtheta=0.02;
theta=0:dtheta:(2*pi+dtheta);

cosfac=cos(mean(points(:,2))*pi/180);

x=rad*cos(theta)/cosfac;
y=rad*sin(theta);
for j=1:size(points,1),
    plot(x+points(j,1),y+points(j,2),col);
end

