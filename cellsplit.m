function[value]=cellsplit(cells,varargin)
if size(cells,1)==1,
  cells=cells';
end

value=cell(size(cells));
for j=1:length(cells),
  crud=strsplit(cells{j},varargin{:});
  value(j,1:length(crud))=crud;
end
