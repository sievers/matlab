function[vals]=read_python_dict(fname)
lll=read_text_file_comments(fname);
for j=1:length(lll),
  ll=lll{j};
  eval([ll ';']);
  nn=strtrim(strtok(ll));
  eval(['vals.' nn ' = ' nn ';']);
end
