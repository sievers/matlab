function[value]=poisson(r,n)
if (~exist('n'))
    n=1;
end

if (r<1480)
    x=exp(0.5*r)*rand(n,1);
    cur=exp(-0.5*r)*ones(n,1);
    value=zeros(n,1);

    for j=1:n
        tot=cur(j);
        while (x(j)>tot)   
            %disp([x tot cur value])
            value(j)=value(j)+1;
            cur(j)=cur(j)*r/value(j);
            tot=tot+cur(j);
        end
    end
else
    %do a gaussian out here
    value=round(r+sqrt(r)*randn([n,1]));
end

return



if (r<1480)
    x=exp(0.5*r)*rand(n,1);
    cur=exp(-0.5*r);
    tot=cur;
    value=zeros(n,1);
    while (x>tot)
        %disp([x tot cur value])
        value=value+1;
        cur=cur*r/value;
        tot=tot+cur;
    end
else
    %do a gaussian out here
    value=round(r+sqrt(r)*gasdev(1));
end

