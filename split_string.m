function[value]=split_string(mystr,delim)
value={};
do_delim=exist('delim');
while (1)
    if do_delim,
        [t,mystr]=strtok(mystr,delim);
    else
        [t,mystr]=strtok(mystr);
    end
    if length(t)>0,
        value=[value;{t}];
    end
    if length(mystr)==0
        return;
    end
end

    