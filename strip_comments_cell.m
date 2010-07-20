function[cells_in]=strip_comments_cell(cells_in,comment_str)
if ~exist('comment_str')
  comment_str='#';
end

keep_ind=ones(size(cells_in));
for j=1:length(cells_in),
    mystr=cells_in{j};
    for k=1:length(comment_str),
      
      ind=min(find(mystr==comment_str(k)));
      if ~isempty(ind),
        mystr=mystr(1:ind-1);      
      end
    end
    if isempty(mystr)
      keep_ind(j)=0;
    else
      cells_in(j)={mystr};    
    end
end

if sum(keep_ind==0)>0
  cells_in=cells_in(keep_ind==1);
end

