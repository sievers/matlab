function[value]=get_keyword_string(keyword,names,vals)
value='';
for j=1:size(names,1),
    check_str=sscanf(names(j,:),'%s');
    if (max(size(keyword))==max(size(check_str)))
        if (check_str==keyword)
            value=strcat(vals(j,:));
        end
    end
end
