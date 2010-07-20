function[value]=find_median_du(u)
upt=get_values(u);
dvec=upt(2:length(upt))-upt(1:length(upt)-1);
value=median(dvec);