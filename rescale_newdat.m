function[value]=rescale_newdat(newdat_in,newdat_out);

[data,errs,ell,bands,which_pols,otherps,corrs,big_curve,errs_upper,ell_low,ell_high,newdat_extras]=read_newdat(newdat_in);
write_newdat(newdat_out,data,errs,ell,bands,which_pols,otherps,corrs,big_curve,errs_upper,ell_low,ell_high,newdat_extras);

