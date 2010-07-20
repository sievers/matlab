function[value]=date_from_ctime(ctime_in,varargin)
ctime_0=datenum(1969,12,31,19,0,0);
mynow=ctime_in/86400+ctime_0;
%value=datstr(mynow,varargin{:})
value=datestr(mynow,varargin{:});

