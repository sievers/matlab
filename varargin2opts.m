function[opts]=varargin2opts(varargin)
for j=1:2:length(varargin)
  eval(['opts.' varargin{j} '=varargin{j+1};']);
end

