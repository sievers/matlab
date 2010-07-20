function[vals]=set_keyword(keyword,newval,names,vals)
%replace FITS keywords by new values



if iscell(keyword),
    assert(iscell(newval));
    assert(length(keyword)==length(newval));
    for j=1:length(keyword),
        vals=set_keyword(keyword{j},newval{j},names,vals);
    end
    return;
end

for j=1:size(names,1),
    check_str=sscanf(names(j,:),'%s');
    if (max(size(keyword))==max(size(check_str)))
        if (check_str==keyword)
            newline=get_char_string(newval,size(vals,2));
            %disp(['.' newline '.']);
            vals(j,:)=newline;
            return
        end
    end
end



function[myline]=get_char_string(val,len)
if ~exist('len')
    len=72;  %default for FITS
end

if isstr(val),
    if length(val)>=len,
        myline=val(1:len);
        return
    end
    myline=[ ' ' val];    
    if length(myline)<len,
        myline(len)=' ';
    end
    
    return
end
if isnumeric(val),
    myline=[' ' num2str(val)];
    if length(myline)>=len,
        myline=myline(1:len);
        return
    end
    myline(72)=' ';
    return
end
warning('unrecognized type in get_char_string');
whos val
disp(val)
return



%%if (nargin>4)
%    default='';
%end%%%
%
%if (nargin>3)
%    value=default;
%end
%for j=1:size(names,1),
%    check_str=sscanf(names(j,:),'%s');
%            value=sscanf(vals(j,:),'%f');
%        end
%    end
%end
