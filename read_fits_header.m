function[header,value]=read_fits_header(fid)
value=read_header_blocks_raw(fid);
value=trim_comments(value);
header=parse_blocks(value);





function[block_in]=read_header_blocks_raw(fid)
block_in=[];
while (1)
  a=fscanf(fid,'%c',[80 36])';
  if isempty(a)
    return;
  end
  for j=1:size(a,1),
    if strcmp('END ',a(j,1:4))
      block_in=[block_in;a(1:j-1,:)];
      return
    end
  end
  block_in=[block_in;a];
end

function[block]=trim_comments(block)
tag='COMMENT';
nrow=size(block,1);
ind=true(nrow,1);
n=length(tag);

for j=1:nrow,
  if (strcmp(tag,block(j,1:n)))
    ind(j)=false;
  end
end
block=block(ind,:);

function[header]=parse_blocks(block)
nrow=size(block,1);
header=cell(nrow,2);

for j=1:nrow,
  ind=min(find(block(j,:)=='/'));
  if isempty(ind)
    ind=80;
  else
    ind=ind-1;
  end

  eq=min(find(block(j,:)=='='));
  
  %assert(~isempty(eq));
  if (~isempty(eq))
    str1=block(j,1:eq-1);
    str2=block(j,eq+1:ind);
    header{j,1}=strtrim(str1);
    ind=find(str2=='''');
    if (length(ind)>=2)
      header{j,2}=strtrim(str2(ind(1)+1:ind(end)-1));
    else
      header{j,2}=my_str2num(str2);
    end
  end
end


function[value]=my_str2num(str)
str=strtrim(str);
if strcmp(str,'F')|strcmp(str,'f')
  value=false;
  return
end
if strcmp(str,'T')|strcmp(str,'t')
  value=true;
  return
end

value=str2num(str);
