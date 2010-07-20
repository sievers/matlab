function[value]=write_newdat(filename,data,errs,ell,bands,which_pols,otherps,corrs,big_curve,errs_upper,ell_low,ell_high,newdat_extras)

pol_tags=['TT'
    'EE'
    'BB'
    'EB'
    'TE'
    'TB'
    'tp'];


fid=fopen(filename,'w');
if (fid==-1)
    error(['Unable to open ' filename ' for writing in write_newdat.']);
end

fprintf(fid,'%s\n',newdat_extras.window_name);
fprintf(fid,'%3d ',newdat_extras.raw_bands);
fprintf(fid,'\n');

if (newdat_extras.band_selection)
    fprintf(fid,'BAND_SELECTION\n');
    for j=1:size(newdat_extras.bands_keep,1),
        fprintf(fid,'%3d %3d\n',newdat_extras.bands_keep(j,1),newdat_extras.bands_keep(j,2));
    end
end
fprintf(fid,'1 %5.3f %7.4f\n',newdat_extras.scale_fac,newdat_extras.calib_err);
fprintf(fid,' 0 0 0\n');  %not sure what this line is supposed to be, will have to update it if I ever use it.
fprintf(fid,' %d #iliketype\n',newdat_extras.iliketype);

for j=1:size(which_pols,1),
    fprintf(fid,'%s\n',which_pols(j,:));
    nb=bands(j);
    for k=1:nb,
        fprintf(fid,'%3d %9.4g %9.4g %9.4g %9.4g    %7.1f %7.1f ',k,data(k,j),errs(k,j),errs_upper(k,j),otherps(k,j),ell_low(k,j),ell_high(k,j));

        if (newdat_extras.iliketype==2)
            fprintf(fid,' %3d\n',newdat_extras.ilikes(k,j));
        else
            fprintf(fid,'\n');
        end
    end
    for k=1:nb,
        fprintf(fid,'%8.3f ',corrs(k,1:nb,j));
        fprintf(fid,'\n');
    end
end

nb=sum(bands);
for j=1:nb
    fprintf(fid,'%12.4e ',big_curve(j,:));
    fprintf(fid,'\n');
end
if newdat_extras.have_sz
    fprintf(fid,'#SZ %8.2f\n',newdat_extras.sz_freq);
end

fclose(fid);

