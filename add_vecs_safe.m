function[vec]=add_vecs_safe(vec1,vec2)
%add two vectors potentially not of the same length and of different alignments.
%returned value is sized the larger of the two.  Alignment is the first argument.
if (min(size(vec1))>1)|(min(size(vec2))>1),
  error(['Sorry, can only add vectors here.']);
end


if numel(vec1)>1,
  if size(vec1,1)==1,
    if size(vec2,1)>1,
      vec2=vec2';
    end
  end
  if size(vec1,2)==1,
    if size(vec2,2)>1,
      vec2=vec2';
    end
  end
end


%at this point, vectors are aligned, though not necessarly of the same length

if numel(vec2)>numel(vec1)
  vec=vec2;
  nn=numel(vec1);
  vec(1:nn)=vec(1:nn)+vec1;
else  
  vec=vec1;
  nn=numel(vec2);
  vec(1:nn)=vec(1:nn)+vec2;  
end