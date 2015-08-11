function [crud ] = myload(filename,varargin)
head_skip=get_keyval_default('head_skip',0,varargin{:});
comment_chars=get_keyval_default('comments','',varargin{:});
% Load in an ascii file, but potentially with blank lines, comments, etc
if iscell(filename)
  lines=filename;
else
  lines=read_text_file_comments(filename);
end
if head_skip>0
  lines=lines(head_skip+1:end);
end

for j=1:length(comment_chars),
  for k=1:length(lines),
    ll=lines{k};
    ll(ll==comment_chars(j))=' ';
    lines(k)=ll;
  end
end


crap=sscanf(lines{1},'%f');
crud=zeros(numel(lines),numel(crap));
jcur=0;
for j=1:numel(lines)
  if ~isempty(strtrim(lines{j}))
    %crap=sscanf(lines{j},'%f')';
    crap=str2num(lines{j});
    if ~isempty(crap),
      nn=size(crud,2);
      if (length(crap<nn))
        crap(end+1:nn)=nan;
      end
      jcur=jcur+1;
      crud(jcur,:)=crap;
    end
  end
end
crud=crud(1:jcur,:);


