function[value]=get_fits_keyval(header,key,default)
if exist('default')
  value=default;
end

for j=1:size(header,1),
  if strcmp(key,header{j,1})
    value=header{j,2};
    return
  end
end
