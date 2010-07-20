function[value]=plot_contour_vec(varargin)
if (min(size(varargin{1}))==1)
    x=varargin{1};
    y=varargin{2};
    varargin=varargin(3:end);
else
    x=1:size(varargin{1},2);
    y=1:size(varargin{1},1);
end
contour_vec=varargin{1};
if length(varargin)>1,
    varargin=varargin(2:end);
else
    varargin={};
end
if length(varargin)>0,
    linestyle=varargin{1};
else
    linestyle='b';
end

hh=ishold;
finished=0;
while (finished==0)
    n_to_plot=contour_vec(2,1);
    plot(contour_vec(1,2:n_to_plot+1),contour_vec(2,2:n_to_plot+1),linestyle);
    hold on;
    contour_vec=contour_vec(:,n_to_plot+2:end);
    if length(contour_vec)<=0,
        finished=1;
    end
end
if (~hh)
    hold off;
end



