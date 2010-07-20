function[value]=cellstr2mat(cells)
value=zeros(size(cells));
for j=1:size(cells,1),
  for k=1:size(cells,2),
    value(j,k)=str2num(cells{j,k});
  end
end

