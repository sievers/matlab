function[script_name]=write_camb_script(params,script_name)
if (nargin<2)
    script_name='run_camb_from_matlab.ini';
end

params_default.get_scalar_cls='T';
fprintf(fid,'get_scalar_cls = %c\n',params_default.get_scalar_cls);
params_default.get_vector_cls='F';
fprintf(fid,'get_vector_cls = %c\n',params_default.get_vector_cls);
params_default.get_tensor_cls='F';
fprintf(fid,'get_tensor_cls = %c\n',params_default.get_tensor_cls);
params_default.get_transfer='F';
fprintf(fid,'get_transfer = %c\n',params_default.get_transfer);

params_default.do_lensing='F';
fprintf(fid,'do_lensing = %c\n',params_default.do_lensing);

%1: curved correlation function, 2: flat correlation function, 3: inaccurate harmonic method
params_default.lensing_method=1;
fprintf(fid,'do_lensing = %d\n',params_default.lensing_method);
params_default.accurate_BB='F';
fprintf(fid,'accurate_BB = %c\n',params_default.accurate_BB);

params_default.scalar_output_file='camb_out.dat';
fprintf(fid,'scalar_output_file = %s\n',params_default.scalar_output_file);

params_default.vector_output_file='';
fprintf(fid,'vector_output_file = %s\n',params_default.vector_output_file);
params_default.tensor_output_file='';
fprintf(fid,'tensor_output_file = %s\n',params_default.tensor_output_file);

params_default.total_output_file='';
fprintf(fid,'total_output_file = %s\n',params_default.total_output_file);
params_default.lensed_output_file='';
fprintf(fid,'lensed_output_file = %s\n',params_default.lensed_output_file);

params_default.l_max_scalar=2000;
fprintf(fid,'l_max_scalar = %d\n',params_default.l_max_scalar);
params_default.k_eta_max_scalar=2*params_default.l_max_scalar;
fprintf(fid,'k_eta_max_scalar = %d\n',params_default.k_eta_max_scalar);

params_default.l_max_tensor=300;
fprintf(fid,'l_max_tensor = %d\n',params_default.l_max_tensor);
params_default.k_eta_max_tensor=2*params_default.l_max_tensor;
fprintf(fid,'k_eta_max_tensor = %d\n',params_default.k_eta_max_tensor);

params_default.use_physical='T';
fprintf(fid,'use_physical = %c\n',params_default.use_physical);

params_default.ombh2=.0219;
fprintf(fid,'k_eta_max_tensor = %d\n',params_default.k_eta_max_tensor);


#Main cosmological parameters, neutrino masses are assumed degenerate
# If use_phyical set phyiscal densities in baryone, CDM and neutrinos + Omega_k
use_physical = T
ombh2 = 0.186163E-01
omch2 = 0.117974E+00
omnuh2         = 0
omk            = 0
hubble = 0.662194E+02
#effective equation of state parameter for dark energy, assumed constant
w              = -1
#constant comoving sound speed of the dark energy (1=quintessence)
cs2_lam        = 1

#if use_physical = F set parameters as here
#omega_baryon   = 0.0462
#omega_cdm      = 0.2538
#omega_lambda   = 0.7
#omega_neutrino = 0

#massless_neutrinos is the effective number (for QED + non-instantaneous decoupling)
temp_cmb           = 2.726
helium_fraction    = 0.24
massless_neutrinos = 3.04
massive_neutrinos  = 0

#Reionization (assumed sharp), ignored unless reionization = T
reionization         = T
re_use_optical_depth = T
re_optical_depth = 0.337596E+00
#If re_use_optical_depth = F then use following, otherwise ignored
re_redshift          = 12
re_ionization_frac   = 1

#Initial power spectrum, amplitude, spectral index and running
initial_power_num         = 1
scalar_amp(1) = 2.83597248621457e-09
scalar_spectral_index(1) = 0.873321E+00
scalar_nrun(1)            = 0
tensor_spectral_index(1)  = 0
#ratio is that of the initial tens/scal power spectrum amplitudes
initial_ratio(1)          = 1
#note vector modes use the scalar settings above

#Initial scalar perturbation mode (adiabatic=1, CDM iso=2, Baryon iso=3, 
# neutrino density iso =4, neutrino velocity iso = 5) 
initial_condition   = 1
#If above is zero, use modes in the following (totally correlated) proportions
#Note: we assume all modes have the same initial power spectrum
initial_vector = -1 0 0 0 0

#For vector modes: 0 for regular (neutrino vorticity mode), 1 for magnetic
vector_mode = 0

#Normalization
COBE_normalize = F
##CMB_outputscale scales the output Cls
#To get MuK^2 set realistic initial amplitude (e.g. scalar_amp(1) = 2.3e-9 above) and
CMB_outputscale = 7.4311e12
#otherwise for dimensionless transfer functions set scalar_amp(1)=1 and use
#CMB_outputscale = 1


#Transfer function settings, transfer_kmax=0.5 is enough for sigma_8
transfer_high_precision = F
transfer_kmax           = 2
transfer_k_per_logint   = 5
transfer_num_redshifts  = 1
transfer_redshift(1)    = 0
transfer_filename(1)    = transfer_out.dat
#Matter power spectrum output against k/h in units of h^3 Mpc^{-3}
transfer_matterpower(1) = matterpower.dat

##Optional parameters to control the computation speed,accuracy and feedback

#If feedback_level > 0 print out useful information computed about the model
feedback_level = 1

#massive_nu_approx: 0 - integrate distribution function
#                   1 - switch to series in velocity weight once non-relativistic
#                   2 - use fast approximate scheme (CMB only- accurate for light neutrinos)
massive_nu_approx = 1

#Whether you are bothered about polarization. 
accurate_polarization   = T

#Whether you are bothered about percent accuracy on EE from reionization
accurate_reionization   = F

#whether or not to include neutrinos in the tensor evolution equations
do_tensor_neutrinos     = F

#Computation parameters
#if number_of_threads=0 assigned automatically
number_of_threads       = 0

#Default scalar accuracy is about 0.3% (except lensed BB). 
#For 0.1%-level try accuracy_boost=2, l_accuracy_boost=2.

#Increase accuracy_boost to decrease time steps, use more k values,  etc.
#Decrease to speed up at cost of worse accuracy. Suggest 0.8 to 3.
accuracy_boost          = 1

#Larger to keep more terms in the hierarchy evolution. 
l_accuracy_boost        = 1

#Increase to use more C_l values for interpolation.
#Increasing a bit will improve the polarization accuracy at l up to 200 -
#interpolation errors may be up to 3%
#Decrease to speed up non-flat models a bit
l_sample_boost          = 1
