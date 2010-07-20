function[h]=plot_circles(x,y,r,varargin)


dohold=ishold(gca);

npt=length(x);
if length(y)~=npt
    error('mismatch in x and y sizes in plot_circles');
end
if (nargout)
    h(size(x))=0;
end
if length(r)==1
    r=r*ones(size(x));
end
dt=0.01;
theta=0:dt:2*pi+dt;
xx=cos(theta);
yy=sin(theta);


if (nargout)
    for j=1:npt,
        h(j)=plot(x(j)+r(j)*xx,y(j)+r(j)*yy,varargin{:});
        hold on;
    end
else
    for j=1:npt,
        plot(x(j)+r(j)*xx,y(j)+r(j)*yy,varargin{:});
        hold on;
    end
end        


if dohold
    hold on;
else
    hold off;
end


%anttab=load('/cita/d/raid-sievers2/sievers/miriad/miriad_cvs/cat/carma_D.ant');
%r=sqrt(anttab(:,1).^2+anttab(:,2).^2);rr=sortrows([r (1:length(r))'],1);rr(1:9,1)=6;rr(10:15,1)=10;rr=sortrows(rr,2);rr=rr(:,1);[r rr]
%plot_circles(anttab(:,1),anttab(:,2),rr)