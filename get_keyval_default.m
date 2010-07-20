function[value,found]=get_keyval_default(key,default,varargin)
value=get_keyval(key,varargin{:});
found=true;
if isempty(value)
    value=default;
    found=false;
end



