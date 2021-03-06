function[data,errs,ell]=wmap_3year_cl_te(do_fine)
if (nargin<1)
    do_fine=0;
end
if (do_fine)
    %low_ell=load('/cita/d/raid-sievers/sievers/cosmo_data/wmap_comb_tt_powspec_3yr_v2_clean_lowell.txt');
    spec=load('/cita/d/raid-sievers/sievers/cosmo_data/wmap_te_powspec_3yr_v2_clean.txt');
    data=spec(:,2);
    errs=spec(:,3);
    ell=spec(:,1);
else
    spec=load('/cita/d/raid-sievers/sievers/cosmo_data/wmap_binned_te_powspec_3yr_v2_clean.txt');
    data=spec(:,4);
    errs=spec(:,5);
    ell=spec(:,1);
end
