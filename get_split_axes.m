function[hand]=get_split_axes(xy,frac,marg)
  if (nargin<3)
    marg=0.12;
end
if (nargin<2)
  frac=0.5;
end

split_x=-1;
if (nargin<1)
  split_x=1;  %default to split in x axis
 else
   if (ischar(xy))
     if (length(xy)==0)
       split_x=1;
     else
       if ((xy(1)=='X')|(xy(1)=='x'))
	 split_x=1;
            end  
if ((xy(1)=='Y')|(xy(1)=='y'))
  split_x=0;
            end
        end
 else
   if (xy>0)
     split_x=1;
   else
     split_x=0;
        end
    end
end

x1=marg;
y1=marg;
splitval=marg+frac*(1-2*marg);
width=1-2*marg;
w1=splitval-marg;
w2=width-splitval;
if (split_x==1)
  h1=axes('position',[marg marg w1 width]);
disp([marg marg w1 width]);
h2=axes('position',[splitval marg w2 width]);
disp([splitval marg w2 width]);
set(h2,'YAxisLocation','Right');
end
if (split_x==0)
  h1=axes('position',[marg marg width w1]);
h2=axes('position',[marg splitval width w2]);
set(h2,'XAxisLocation','Top');
end
hand=[h1 h2 split_x];
