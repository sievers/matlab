function[big_data,big_errs,big_ell,big_bands,big_otherps,big_corrw,big_curve,big_errs_upper,big_ell_low,big_ell_high,nfiles]=...
    read_newdat_set(varargin)
if (iscell(varargin{1}))
    have_names=1;
    filenames=varargin{1};
else
    have_names=0;
    fileroot=varargin{1};
    filetail=varargin{2};
    %nfiles=varargin{3};
end



if (have_names)
    nfiles=length(filenames)
else
    nfiles=1;
    ok=1;
    while (ok==1)
        fid=fopen([fileroot num2str(nfiles) filetail],'r');
        if (fid==-1)
            ok=0;
            nfiles=nfiles-1;
        else
            nfiles=nfiles+1;
            fclose(fid);
        end
    end
    disp(['nfiles is ' num2str(nfiles)])
end

for j=nfiles:-1:1,
    if (have_names)
        [data,errs,ell,bands,which_pols,otherps,corrs,curve,errs_upper,ell_low,ell_high]=read_newdat(filenames{j});
    else
        [data,errs,ell,bands,which_pols,otherps,corrs,curve,errs_upper,ell_low,ell_high]=read_newdat([fileroot num2str(j) filetail]);
    end
    disp(['j is ' num2str(j)])
    big_data(:,:,j)=data;
    big_errs(:,:,j)=errs;
    big_ell(:,:,j)=ell;
    big_bands(:,:,j)=bands;
    big_otherps(:,:,j)=otherps;
    big_corrs(:,:,j)=corrs;
    big_curve(:,:,j)=curve;
    big_errs_upper(:,:,j)=errs_upper;
    big_ell_low(:,:,j)=ell_low;
    big_ell_high(:,:,j)=ell_high;
end
%if we only have one polarization, drop the extra dimension
big_data=squeeze(big_data);
big_errs=squeeze(big_errs);
big_ell=squeeze(big_ell);
big_bands=squeeze(big_bands);
big_otherps=squeeze(big_otherps);
