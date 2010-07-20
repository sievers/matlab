function[val]=get_struct_mem(opts,name,default)
if nargin<2
    error('Need a structure and a search tag in get_struct_mem.');
end
if (~ischar(name))
    error('Field name must be a string in get_struct_mem.');
end
if (~isstruct(opts))
    error('First argument must be a structure in get_struct_mem.');
end

if ~exist('default')
    default=[];
end

if isfield(opts,name)
    val=eval(['opts.' name]);
else
    val=default;
end
