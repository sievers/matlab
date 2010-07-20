function[new_spec]=rescale_spec(spec,new_x,scale,old_x)
if (nargin<4)
    old_x=1+(1:max(size(spec)));
end
new_spec=interp1(old_x/scale,spec,new_x,'spline',0);
new_spec(isnan(new_spec))=0;
