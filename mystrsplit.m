function[tags]=mystrsplit(str,delim)
fwee=[];
for j=1:numel(delim),
    fwee=[fwee find(str==delim(j))];
end
fwee=sort(fwee);
if isempty(fwee)
  warning(['did not find delimiters in ' str]);
  tags='';
  return
end

tags={};
if fwee(1)>1
    tags(1)={str(1:fwee(1)-1)};
end
for j=1:numel(fwee)-1,
    if fwee(j+1)-fwee(j)>1,
        tags(end+1)={str( (fwee(j)+1):(fwee(j+1)-1))};
    end
end
if fwee(end)<numel(str),
    tags(end+1)={str(fwee(end)+1:end)};
end
