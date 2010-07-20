function[varargout]=plot_offset(vec,dx,varargin)
vec=vec(1:dx:length(vec));
n=length(vec);
h=plot(vec(1:n-1),vec(2:n),varargin{:});

if (nargout)==1
    varargout=h;
    return;
end
if (nargout)==2
    varargout{1}=vec(1:n-1);
    varargout{2}=vec(2:n);
    return;
end
if (nargout==3)
    varargout{1}=h;
    varargout{2}=vec(1:n-1);
    varargout{3}=vec(2:n);
end
