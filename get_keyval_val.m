function[value]=get_keyval_val(targ,names,vals)

for j=1:length(names),
  if (strcmp(targ,names{j}))
    value=vals{j};
    return
  end
end
value=[];

