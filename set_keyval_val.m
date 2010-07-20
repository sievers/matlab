function[names,vals]=set_keyval_val(targ,value,names,vals)
%function[names,vals]=set_keyval_val(targ,value,names,vals)
%set a keyword targ to value.  If it doesn't exist, add onto the list.

for j=1:length(names),
  if (strcmp(targ,names{j}))
    vals(j)={value};
    return
  end
end
names(end+1)={targ};
vals(end+1)={value};

