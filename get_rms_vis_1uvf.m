function[big_sig]=get_rms_vis_1uvf(fname,exe,rowname,txtname)
if (~exist('rowname'))
    rowname='temp_row.txt';
end
if (~exist('txtname'))
    txtname='temp_vis.txt';
end
if (~exist('exe')|(~length(exe)))
    exe='/cita/d/raid-sievers/sievers/bin//uvf2rows';
end


crud=fopen(fname,'r');
if (crud==-1)
    error(['file .' fname '. missing.']);
else
    fclose(crud);
end
system([exe ' ' fname ' ' rowname ' -1 0 >& /dev/null']);
mystr=(['awk ''{printf("%14.4e %14.4e\n",$10,$12)}'' < ' rowname ' > ' txtname]);
system(mystr);
crud=load(txtname);
big_sig=sqrt(mean(crud(:,1).^2+crud(:,2).^2));
