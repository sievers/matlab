function[hand]=split_set_all(h,varargin)
for j=1:length(h)
    if (h(j)>0)
        set(h(j),varargin{:});
    end
end
