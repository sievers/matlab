function[h,dataft]=plot_ps(data,varargin)
detrend=get_keyval_default('detrend',false,varargin{:});
window=get_keyval_default('window',false,varargin{:});
smooth_width=get_keyval_default('smooth',0,varargin{:});
dt=get_keyval_default('dt',1,varargin{:});

if (detrend)
    data=detrend_data(data);
end
if (window)
    window_width=get_keyval_default('window_width',0.01,varargin{:})
    data=window_data(data,window_width);
end


dataft=abs(fft(data)).^2;
n=size(data,1);
nu=(0:n-1)/(n*dt);



if (smooth_width>0)
    dataft=smooth_data_fft(dataft,smooth_width);
end
dataft=dataft(1:floor( (n+1)/2),:);
nu=nu(1:size(dataft,1));
nu(1)=0.5*nu(2);
col=get_keyval_default('color','',varargin{:});
args={nu,dataft};
if ~isempty(col)
    args(end+1)=col;
end


if get_keyval_default('loglog',true,varargin{:}),
    %h=loglog(nu,dataft,col);
    h=loglog(args{:});
else
    h=plot(args{:});
    %h=plot(nu,dataft,col);
end

if nargout==0
    clear h;
end



