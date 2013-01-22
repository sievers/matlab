function [crud ] = myload(filename)
% Load in an ascii file, but potentially with blank lines, comments, etc
if iscell(filename)
  lines=filename;
else
  lines=read_text_file_comments(filename);
end
crap=sscanf(lines{1},'%f');
crud=zeros(numel(lines),numel(crap));
jcur=0;
for j=1:numel(lines)
  if ~isempty(strtrim(lines{j}))
    %crap=sscanf(lines{j},'%f')';
    crap=str2num(lines{j});
    if ~isempty(crap),
      jcur=jcur+1;
      crud(jcur,:)=crap;
    end
  end
end
crud=crud(1:jcur,:);


