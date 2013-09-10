function[nlines]=write_fits_header_line_test(fid,name,value,strtype)

if length(name)>7
  disp(['name ' name ' too long - truncating.']);
  name=name(1:7);
end
if strcmp(lower(name),'comment')
  %disp('doing comment stuff.');
  mylines=_string_to_comment(value);
  if isempty(mylines)  %respect if someone has put in a comment
    mylines={''};
  end
  for j=1:length(mylines),
    fprintf(fid,'COMMENT %-72s',mylines{j});
  end
  nlines= length(mylines);
  return
end

if strcmp(lower(name),'end')
  myline='END';
  myline(end+1:80)=' ';
else
  %if ischar(value)
  %  myline=sprintf('%-7s = %s',name,value);
  %else
  %  myline=sprintf('%-7s = %g',name,value);
  %end
  myline=sprintf('%-7s = %s',name,_safe_g(value));
  if length(myline)<80
    myline(end+1:80)=' ';
  end
end
fprintf(fid,'%s',myline);
nlines=1;
return



function[mylines]=_string_to_comment(mystr)
mylines={};
maxlen=72;
while length(mystr)>maxlen,
  mylines{end+1}=mystr(1:maxlen);
  mystr=mystr(maxlen+1:end);
end
if ~isempty(mystr)
  mylines(end+1)=mystr;
end


function[mystr]=_safe_g(val)
if ischar(val)
  mystr=val;
  return
end
mystr=sprintf('%g',val);
if val~=0,
  vv=str2num(mystr);
  if abs(vv-val)/abs(val)>1e-14,
    mystr=sprintf('%20.16g',val);
  end
end
return