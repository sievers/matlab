function[hand]=split_set(h,varargin)

if (h(1)~=-1)
    set(h(1),varargin{:});
end
if (h(2)~= -2)
    set(h(2),varargin{:});
end

