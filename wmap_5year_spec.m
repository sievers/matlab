function[cl,cl_unlensed]=wmap_5year_spec()
%cl=load('/cita/d/raid-sievers/sievers/wmap.cmb');
%cl=load('/cita/d/raid-sievers/sievers/cosmo_data/WMAP3_only.cl');
cl=load('/cita/d/raid-sievers2/sievers/combined_tt/11Dec07_src/params_wmap5/cl_bestfit_wmap5_CMBall_KSSZ_lens.dat_lensed.dat');
cl_unlensed=load('/cita/d/raid-sievers2/sievers/combined_tt/11Dec07_src/params_wmap5/cl_bestfit_wmap5_CMBall_KSSZ_lens.dat_scalCls.dat');
