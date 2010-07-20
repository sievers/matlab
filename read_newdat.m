function[data,errs,ell,bands,which_pols,otherps,corrs,big_curve,errs_upper,ell_low,ell_high,newdat_extras]=read_newdat(filename,skip_scale)
%read a .newdat.  Send in true for the second argument if you want to not
%apply the calibration factor.

pol_tags=['TT'
    'EE'
    'BB'
    'EB'
    'TE'
    'TB'
    'tp'];
fid=fopen(filename,'r');
if (fid==-1)
    error(['Error in read_newdat:  unable to open ' filename ' for reading.']);
end

%read filename
line_in=fgetl(fid);
newdat_extras.window_name=line_in;

%read bin info
line_in=fgets(fid);
which_bands=sscanf(line_in,'%f');
which_pols=pol_tags((which_bands >0),:);
npols=sum(which_bands>0);
bands=which_bands(which_bands>0);
newdat_extras.raw_bands=which_bands;


newdat_extras.band_selection=0;
%line_in=fgetl(fid);
line_in=fgetl(fid);

if (strcmp(line_in,'BAND_SELECTION'))
    newdat_extras.band_selection=1;
    for j=1:6,
        line_in=fgets(fid);
        crud=sscanf(line_in,'%d');
        if length(crud)~=2
            error('Problem reading newdat with BAND_SELECTION.');
        end
        bands_keep(j,:)=crud;
    end
    %bands_keep
    %now read the next line, which was the one we were expecting.
    line_in=fgets(fid);
else
    bands_keep(1:6,1:2)=0;
    bands_keep((which_bands>0),2)=which_bands(which_bands>0);
    bands_keep((which_bands>0),1)=1;
end
newdat_extras.bands_keep=bands_keep;
    
scale_fac=sscanf(line_in,'%f');
newdat_extras.scale_fac=1.0;
if (exist('skip_scale'))
    if (skip_scale)
        newdat_extras.scale_fac=scale_fac(2);  %save the scale factor if we're skipping it
        scale_fac(2)=1;
    end
end


newdat_extras.calib_err=scale_fac(3);
scale_fac=scale_fac(2)^2;

line_in=fgets(fid); %all zeros for CBI

line_in=fgets(fid); %iliketype
[a,b]=strtok(line_in);
iliketype=str2num(a);
newdat_extras.iliketype=iliketype;

for j=1:npols,
%    disp([j bands(j)])
    line_in=fgets(fid);
    if (j>1)
        line_in=fgets(fid);
    end
    clear block_in
    for k=1:bands(j),
        line_in=fgetl(fid);
        %[block_in(1,j) block_in(2,j) block_in(3,j) block_in(4,j)
        %block_in(5,j) block_in(6,j) block_in(7,j)]=sscanf(line_in,'%f%f%f%f%f%f%f');
        %disp(bands(1,j));
        if (iliketype==2)
            block_in(k,1:8)=sscanf(line_in,'%f',[1 8]);
        else
            block_in(k,1:7)=sscanf(line_in,'%f',[1 7]);
        end
    end
    %block_in=(fscanf(fid,'%f',[7 bands(j)]))';
    data(1:bands(j),j)=block_in(:,2)*scale_fac;
    errs(1:bands(j),j)=block_in(:,3)*scale_fac;
    errs_upper(1:bands(j),j)=block_in(:,4)*scale_fac;
    otherps(1:bands(j),j)=block_in(:,5)*scale_fac;
    ell(1:bands(j),j)=0.5*(block_in(:,6)+block_in(:,7));
    ell_low(1:bands(j),j)=block_in(:,6);
    ell_high(1:bands(j),j)=block_in(:,7);
    if (size(block_in,1)>1)
        ell(1,j)=2*block_in(2,6)-ell(2,j);
        ell(bands(j),j)=2*block_in(bands(j)-1,7)-ell(bands(j)-1,j);
    end
    if (iliketype==2)
        newdat_extras.ilikes(1:bands(j),j)=block_in(:,8);
    end
    block_in=fscanf(fid,'%f',[bands(j) bands(j)]);
    corrs(1:bands(j),1:bands(j),j)=block_in;
    
    %for m=1:bands(j),
    %    for n=1:bands(j),
    %        corrs(m,n,j)=block_in(m,n)*errs(m,j)*errs(n,j);
    %    end
    % end
end
total_bands=sum(bands);
big_curve=fscanf(fid,'%f',[total_bands total_bands]);
big_curve=big_curve*scale_fac*scale_fac;
%if (mean(mean(abs(big_curve)))>1e-14)
%    big_curve=big_curve/(2.725e5^4);
%end
line_in=fgetl(fid);
if isstr(line_in)
    [a,b]=strtok(line_in);
    if (strcmp(a,'#SZ'))
        newdat_extras.have_sz=1;
        newdat_extras.sz_freq=str2num(b);
    else
        newdat_extras.have_sz=0;
        newdat_extras.sz_freq=0;
    end
end


fclose(fid);

