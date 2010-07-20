function[heights]=get_contour_levels(mat,levels)
%function[value]=get_contour_levels(mat,levels)
%for an input 2-d density matrix, find the density levels that correspond
%to the enclosed probability levels in levels.  e.g. if levels==0.68,
%return the density corresponding to 68% of the enclosed probability in mat

if ~exist('levels')
    levels=[0.68 0.95];
end


crud=sort(reshape(mat,[numel(mat) 1]));
crudsum=cumsum(crud)/sum(crud);
heights=0*levels;
for j=1:length(levels),
    ind=crudsum>(1-levels(j));
    crap=crud(ind);
    heights(j)=crap(1);
end
