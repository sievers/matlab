function[value,x,theta]=cell_area(a,r,R)
x=0;
theta=0;
if (R>a+r)
    value=0;
else
    if (r>a+R)
        value=pi*a^2;
    else
        phi=acos((R^2+r^2-a^2)/(2*r*R));
        %        if (r<R)
        theta=acos((R^2+a^2-r^2)/(2*a*R));
    %            theta=asin(r*sin(phi)/a);
%            if (r>R)
%                theta=pi-theta;
%            end
            x=a*sin(theta);
%            phi=asin(a*sin(theta)/r);
            value=a^2*theta+r^2*phi-R*x;
%        else
            
        end
end

%theta=asin(a/R);
%if (abs(theta)<-0.1)
%    cost=abs(r-R)/a;
%    phi=acos(cost);
%    aa=(phi-0.5*sin(2*phi))/pi;
%    if (r<R)
%        value=aa;
%    else
%        value=1-aa;
%    end
%    value=value*pi*a^2;
%end
