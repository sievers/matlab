function[value]=plot_cosmomc_contour_set(varargin)
%overplot contours of cosmomc parameter results
%sample usage:
%  nm1='plot_data/WMAP3_cbiCombNoMargeSrc2Raw_s8sz_Marcelloamp';
%  nm2='plot_data/WMAP3_cbiCombMargeSrc2Raw_s8sz_Marcelloamp';
%  plot_cosmomc_contour_set({nm2,nm1,nm2},{'ns','ns','ns'},{'s8sz','s8sz','s8'});



%check to see if we have a list of names, or a cell structure
have_cols=0;
if (iscell(varargin{1}))
    names=varargin{1};
    lab1=varargin{2};
    lab2=varargin{3};
    have_cols=0;
    have_opts=0;
    if (length(varargin)>=4)
        for j=length(varargin):-1:4
          if isstruct(varargin{j})
            opts=varargin{j};
            have_opts=1;
          end
          if isnumeric(varargin{j})
            cols=varargin{j};
            have_cols=1;
          end
        end   
        disp([' have_opts and have_cols are ' num2str([have_opts have_cols])])
        %cols=varargin{4};
        %have_cols=1;
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
    if (iscell(lab1))
        big_dat{j}=read_2d_cosmomc_data(names{j},lab1{j},lab2{j});
    else
        big_dat{j}=read_2d_cosmomc_data(names{j},lab1,lab2);
    end
    if (have_opts)
      if isfield(opts,'xscale')
        big_dat{j}.x=big_dat{j}.x*opts.xscale;        
      end
      if isfield(opts,'yscale')
        big_dat{j}.y=big_dat{j}.y*opts.yscale;        
      end
    end
end
%whos
%big_dat
if (have_cols)
    plot_contours_cosmomc(big_dat,cols);
else
    plot_contours_cosmomc(big_dat);
end
if (iscell(lab1))
    lab1=lab1{1};
end
if (iscell(lab2))
    lab2=lab2{1};
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
