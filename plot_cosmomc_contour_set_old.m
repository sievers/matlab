function[value]=plot_cosmomc_contour_set(varargin)
%check to see if we have a list of names, or a cell structure
have_cols=0;
if (iscell(varargin{1}))
    names=varargin{1};
    lab1=varargin{2};
    lab2=varargin{3};
    have_cols=0;
    if (length(varargin)==4)
        cols=varargin{4};
        have_cols=1;
    end
else
    narg=length(varargin);
    if (isstr(varargin{narg}))
        have_cols=0;
        for j=(narg-2):-1:1,
            names{j}=varargin{j};
        end
        lab1=varargin{narg-1};
        lab2=varargin{narg};
    else
        have_cols=1;
        for j=(narg-3):-1:1,
            names{j}=varargin{j};
        end
        lab1=varargin{narg-2};
        lab2=varargin{narg-1};
        cols=varargin{narg};
    end
end
ntoplot=length(names);
for j=1:ntoplot,
    big_dat{j}=read_2d_cosmomc_data(names{j},lab1,lab2);
end
whos
big_dat
if (have_cols)
    plot_contours_cosmomc(big_dat,cols);
else
    plot_contours_cosmomc(big_dat);
end
[a,b]=cosmomc_labs(lab1);
[c,d]=cosmomc_labs(lab2);
if (b<d)
    hx=xlabel(a);
    hy=ylabel(c);
else
    hx=xlabel(c);
    hy=ylabel(a);
end
set(hx,'FontSize',18);
set(hy,'FontSize',18);
%legend_good('','','','fwok','','flibble');