function[value]=get_keyword(keyword,names,vals,default)

if (nargin>4)
    default='';
end

if (nargin>3)
    value=default;
end
for j=1:size(names,1),
    check_str=sscanf(names(j,:),'%s');
    if (max(size(keyword))==max(size(check_str)))
        if (check_str==keyword)
            value=sscanf(vals(j,:),'%f');
        end
    end
end
