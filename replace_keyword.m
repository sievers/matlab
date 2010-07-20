function[vals]=replace_keyword(keyword,names,vals_org,newval)

vals=vals_org;

for j=1:size(names,1),
    check_str=sscanf(names(j,:),'%s');
    if (max(size(keyword))==max(size(check_str)))
        if (check_str==keyword)
            vals(j,:)=' ';
            if (isstr(newval))
                vals(j,1:length(newval))=newval;
            else
                fwee=num2str(newval);
                vals(j,1:length(fwee))=fwee;
            end
        end
    end
end
