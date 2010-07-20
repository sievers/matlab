function[tags]=big_strtok(line_in)
j=0;
b=line_in;
while (1)
    [a,b]=strtok(b);
    if (length(a)>0)
        j=j+1;
        tags{j}=a;
    else
        return;
    end
end
