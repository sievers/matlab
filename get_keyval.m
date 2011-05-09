function[value]=get_keyval(key,varargin)
%find a key from input argument list.  return null on misbehavior.
assert(ischar(key));
tf=strcmp(key,varargin);
if sum(tf)>1,
    warning(['keyword ' key ' specified multiple times in get_keyval.']);

    %value=[];
    %return
    %change so that instead of exiting, it uses the first instance
    ind=tf>0;
    tf(ind(2:end))=0;
end

if sum(tf)==0,
    value=[];
    return;
end

%single instance here
[a,b]=max(tf);
if (b<length(tf));
    value=varargin{b+1};
    return
end
    
value=[];
return;
    
