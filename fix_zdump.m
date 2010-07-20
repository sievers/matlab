function [estmap,count]=fix_zdump(vec,zdump)

%estmap=vec./zdump;
D=zdump;N=vec;
count=0; 
i=1;
%index=0;
while i<=length(zdump)
    if (zdump(i)==0) 
%        count=count+1;
        index=i-count;
        D(index)=[];
        N(index)=[];
        count=count+1;
    end;
    i=i+1;
end;

%disp([size(D) size(vec)])
count=0; 
for i=1:1:length(D)
    if (D(i)==0) 
        count=count+1;
    end;
end;

D;
count;%check whether all zeros are removed
estmap=N./D;