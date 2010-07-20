function[value]=isnewer(fname1,fname2)
date1=get_file_creation_dates(fname1);
date2=get_file_creation_dates(fname2);

if (length(date1)>1)&(length(date2)>1)
    error('Too many files in function isnewer.  Both filenames have multiple sets.');
end

value=(date1>date2);

%if (date1>date2)
%    value=true;
%else
%    value=false;
%end
