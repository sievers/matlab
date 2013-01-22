function[mystr]=strip_trailing_slashes(mystr)
if iscell(mystr)
  for j=1:length(mystr)
    ss=mystr{j};
    if ss(end)=='/'
      ss=ss(1:end-1);
      mystr(j)={ss};
    end
  end
else
  if mystr(end)=='/'
    mystr=mystr(1:end-1);
  end
end

