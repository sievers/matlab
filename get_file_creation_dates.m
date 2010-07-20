function[value]=get_file_creation_dates(varargin)
% 2007-04-01 21:26:58.000000000

if length(varargin)==1
    value=get_file_creation_dates_one_set(varargin{1});
else
    for j=1:length(varargin),
        crud=get_file_creation_dates_one_set(varargin{j});
        len(j)=length(crud);
        crap{j}=crud;
    end
    if ((max(len)==1)&(min(len)==1))
        for j=length(varargin):-1:1,
            value(j)=crap{j};
        end
    else
        value=crud;
    end
end


function[value]=get_file_creation_dates_one_set(fname)
[a,b]=system(['ls -l  --time-style=full-iso ' fname]);
%not_found='ls: No match.';
not_found='ls: ';
if (b(1:length(not_found))==not_found)
    value=[];
else
    nlines=sum(b==10);
    vec=1:length(b);
    ind_stop=vec(b==10)-1;
    ind_start=[1 (ind_stop(1:nlines-1)+2)];
    for j=1:nlines,
        line_use=b(ind_start(j):ind_stop(j));
        %value(j)=get_date_one_line(line_use);
        %disp([ num2str(j) '  ' b(ind_start(j):ind_stop(j))]);
        %disp([ num2str(j) '  ' line_use]);
        value(j)=get_date_one_line(line_use);
    end
    %value=0;
end


function[value]=get_date_one_line(d);
[c,d]=strtok(d);
[c,d]=strtok(d);
[c,d]=strtok(d);
[c,d]=strtok(d);
[c,d]=strtok(d);
[which_day,d]=strtok(d);
[which_hour,d]=strtok(d);

which_day(which_day=='-')=' ';
[yr,d]=strtok(which_day);
[month,d]=strtok(d);
day=strtok(d);
day=datenum(str2num(yr),str2num(month),str2num(day));

which_hour(which_hour==':')=' ';
[hour,d]=strtok(which_hour);
[min,d]=strtok(d);
sec=strtok(d);

hour=str2num(hour);
min=str2num(min);
sec=str2num(sec);

time=(hour+min/60+sec/3600)/24;
value=day+time;

%disp([which_day '  ' which_hour '   ' num2str(day) '   ' num2str(time)]);
