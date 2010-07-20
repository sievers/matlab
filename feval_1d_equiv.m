function[a,b,c]=feval_1d_equiv(func_handle,x,orig,direction,varargin)
do_flip=isa(func_handle,'function_handle');
if (do_flip==0)
    flub=x;
    x=func_handle;
    func_handle=flub;
end

if (nargout<=1)
    a=feval(func_handle,orig+x*direction,varargin{:});
end
if (nargout==2)
    [a,b]=feval(func_handle,orig+x*direction,varargin{:});
    slope=sum(direction.*b);
    b=[slope;b];
end
if (nargout==3)
    [a,b,c]=feval(func_handle,orig+x*direction,varargin{:});
    slope=sum(direction.*b);
    b=[slope;b];

end
