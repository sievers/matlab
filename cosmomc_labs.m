function[lab,ind]=cosmomc_labs(str)
%    1  0.236088E-01  0.120818E-02  0.224330E-01  0.247923E-01  0.215416E-01  0.262745E-01   \Omega_b h^2
%    2  0.942179E-01  0.996251E-02  0.842076E-01  0.104011E+00  0.746818E-01  0.113518E+00   \Omega_c h^2
%    3  0.104224E+01  0.420214E-02  0.103817E+01  0.104636E+01  0.103418E+01  0.105083E+01   \theta
%    4  0.975568E-01  0.320101E-01  0.829015E-01  0.111571E+00  0.448867E-01  0.151301E+00   \tau
%    8  0.102647E+01  0.578710E+00  0.664524E+00  0.140263E+01  0.113840E+00  0.190454E+01   \alpha_{SZ}
%    9  0.993998E+00  0.334336E-01  0.961275E+00  0.102771E+01  0.938590E+00  0.106792E+01   n_s
%   12  0.300062E+01  0.734222E-01  0.292805E+01  0.307178E+01  0.285307E+01  0.314691E+01   log[10^{10} A_s]
%   13  0.287918E+00  0.198602E+00  0.818939E-01  0.498904E+00  0.134268E-01  0.734672E+00   R
%   15  0.812507E+00  0.400982E-01  0.771889E+00  0.853055E+00  0.730540E+00  0.883923E+00   \Omega_\Lambda
%   16  0.134266E+02  0.260554E+00  0.131631E+02  0.136807E+02  0.128578E+02  0.138722E+02   Age/GYr
%   17  0.187493E+00  0.400982E-01  0.146950E+00  0.228113E+00  0.116086E+00  0.269461E+00   \Omega_m
%   18  0.701306E+00  0.610529E-01  0.641646E+00  0.761021E+00  0.576202E+00  0.820653E+00   \sigma_8
%   19  0.110728E+02  0.249111E+01  0.871511E+01  0.134370E+02  0.544665E+01  0.155670E+02   z_{re}
%   20  0.953185E+00  0.213866E+00  0.730099E+00  0.115959E+01  0.421661E+00  0.121064E+01   \sigma_8^{\alpha}
%   21  0.802735E+02  0.580153E+01  0.745323E+02  0.861180E+02  0.706178E+02  0.931999E+02   H_0

do_cosmic_string=true;

labs{1}='\Omega_b h^2';
labs{2}='\Omega_c h^2';
labs{3}='\theta';
labs{4}='\tau';
labs{8}='q_{SZ}';
labs{9}='n_s';
labs{11}='n_{run}';
labs{12}='log[10^{10} A_s]';
labs{13}='R';
labs{14}='\Omega_Mh';
labs{15}='\Omega_\Lambda';
labs{16}='Age/GYr';
labs{17}='\Omega_m';
labs{18}='\sigma_8';
labs{19}='z_{re}';
labs{20}='\sigma_8^{\alpha}';
labs{21}='H_0';

targ1={labs{1};'omb';'omB';'ombh2';'ombh^2';'omb_h^2'};
targ2={labs{2};'omc';'omC';'omch2';'omch^2';'omc_h^2'};
targ3={labs{3};'theta'};
targ4={labs{4};'tau'};
targ8={labs{8};'qsz';'q_sz';'asz';'a_sz';'A_sz'};
targ9={labs{9};'n';'ns'};
targ11={labs{11};'nrun';'n_run'};
targ12={labs{12};'a';'as';'a_s';'amp'};
targ13={labs{13};'r';'amp_ratio';'amp ratio';'tens';'tensor'};
targ14={labs{14};'omh';'Omh';'o_mh'};
targ15={labs{15};'lambda';'lamda';'oml';'Oml'};
targ16={labs{16};'age';'t0'};
targ17={labs{17};'Om';'Omega m';'Omega_m';'Omega_M'};
targ18={labs{18};'s8';'sigma_8';'sigma 8';'s_8';'sigma_8'};
targ19={labs{19};'z_re';'z_recomb';'zre';'z'};
targ20={labs{20};'s8_sz';'s8_alpha';'s8_SZ';'s8sz'};
targ21={labs{21};'h';'h0';'H0';'h_0';'hubble';'Hubble'};
%big_targs={targ1;targ2;targ3;targ4;targ8;targ9;targ12;targ13;targ15;targ16;targ17;targ18;targ19;targ20;targ21};

if (do_cosmic_string)
  labs{14}='q_{string}';
  targ14={labs{14};'qs'};
  labs{16}='G_{\mu}';
  targ16={labs{16};'gmu';'g_mu';'Gmu';'G_mu'};
end


big_targs{1}=targ1;
big_targs{2}=targ2;
big_targs{3}=targ3;
big_targs{4}=targ4;
big_targs{8}=targ8;
big_targs{9}=targ9;
big_targs{11}=targ11;
big_targs{12}=targ12;
big_targs{13}=targ13;
big_targs{14}=targ14;
big_targs{15}=targ15;
big_targs{16}=targ16;
big_targs{17}=targ17;
big_targs{18}=targ18;
big_targs{19}=targ19;
big_targs{20}=targ20;
big_targs{21}=targ21;

ind=get_ind(big_targs,str);
if (ind>0)
    lab=labs{ind};
else
    whos str
    disp(['unkown target string ' str '.']);
    lab='';
end






%-----------------------------------------------------------%

function[ind]=get_ind(big_targs,str)
ind=-1;
for j=1:length(big_targs)
    if (is_in_targ_list(big_targs{j},str))
        ind=j;
    end
    if (ind==-1)
        for j=1:length(big_targs)
            if (is_in_targ_list_lower(big_targs{j},str))
                ind=j;
            end
        end
    end
        
end





%---------------------------------------------------------%
function[amihere]=is_in_targ_list(targs,str)
amihere=0;
for j=1:length(targs)
    %if (targs{j}==str)
    if (strcmp(targs{j},str))
        amihere=1;
    end
end

%----------------------------------------------------------%

function[amihere]=is_in_targ_list_lower(targs,str)
amihere=0;
for j=1:length(targs)
%    if (lower(targs{j})==lower(str))
if (strcmp(lower(targs{j}),lower(str)))
        amihere=1;
    end
end


