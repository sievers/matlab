function[value]=split_axis(hh,lims)
  if (hh(3)==1) %do x-axis case
    axes(hh(1));
axis([lims(1) lims(2) lims(4) lims(5)]);
axes(hh(2));
axis([lims(2) lims(3) lims(4) lims(5)]);
 else
   axes(hh(1));
axis([lims(1) lims(2) lims(3) lims(4)]);
axes(hh(2));
axis([lims(1) lims(2) lims(4) lims(5)]);
end
