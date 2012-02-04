function[lines]=fuse_cell_lines(lines,tag)
if ~exist('tag')
  tag='\';
end
to_merge=false(size(lines));

taglen=numel(tag);
nl=length(lines)-1;  %always skip the last line 'cause I don't know how to merge it with null
for j=1:nl,
  ll=lines{j};
  if length(ll)>=taglen,
    if strcmp(ll(end-taglen+1:end),tag)
      to_merge(j)=true;
      lines(j)={ll(1:end-taglen)}; %trim out the continue tag
    end
  end
end

%now that we've found all the lines we want to keep, sweep through and push lines to be merged forwards
for j=1:nl, 
  if to_merge(j),
    lines(j+1)={[lines{j} lines{j+1}]};
  end
end
%now purge lines we've merged
lines=lines(~to_merge);

