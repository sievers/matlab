function [crud ] = myload(filename)
% Load in an ascii file, but potentially with blank lines, comments, etc
lines=read_text_file_comments(filename);
crap=sscanf(lines{1},'%f');
crud=zeros(numel(lines),numel(crap));
jcur=0;
for j=1:numel(lines)
    crap=sscanf(lines{j},'%f')';
    if ~isempty(crap),
        jcur=jcur+1;
        crud(jcur,:)=crap;
    end
end
crud=crud(1:jcur,:);


