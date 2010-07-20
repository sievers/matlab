function[value]=split_string_line(line_in,numeric_is_string)

%value=isnumbers(line_in);
%return
if (nargin<2)
    numeric_is_string=0;
end

j=0;
while (length(line_in)>0)
    j=j+1;
    [tok,line_in]=strtok(line_in);
    value{j}=tok;
end
n=j;
if (~numeric_is_string)
    for j=1:n,
        if (isnumbers(value{j}))
            value{j}=str2num(value{j});
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

function[isnum]=isnumbers(str)
str=str(str~=' ');
isnum=(str>47)&(str<58);


n=length(str);
isexp=(str=='e')|(str=='E');
if sum(isexp>1)
    isnum=0;
    return;
end
if (sum(isexp)==1)
    [a,epos]=max(isexp);
    haveexp=1;
else
    haveexp=0;
    epos=0;
end



isdot=(str=='.');
if (sum(isdot)==1)&(haveexp)
    %if there's a decminal point, make sure it's to the left of the
    %exponent
    [a,dotpos]=max(isdot);
    if (dotpos>epos)
        isnum=0;
        return
    end
end

isplus= (str=='+');
isminus=(str=='-');
if sum(isdot)>1
    isnum=0;
    return
end
if (sum(isplus(2:n))+sum(isminus(2:n)))>1
    isnum=0;
    return;
end
if (sum(isplus(2:n))+sum(isminus(2:n))==1)
    if (haveexp==0)
        isnum=0;
        return;
    end
    [a,pluspos]=max(isplus(2:n));
    [a,minuspos]=max(isminus(2:n));
    pos=max([pluspos minuspos])+1;
    if pos~=epos+1
        isnum=0;
        return
    end
end

isnum=isnum|isdot|isplus|isminus|isexp;
if (min(isnum)==0)
    isnum=0;
else
    isnum=1;
end

    
