function[value]=sz_fac_kompaneets(nu)
%nu in GHz

h=6.63e-27;
k=1.38e-16;
T=2.725;
x=h*nu/k/T*1e9; %frequency in GHz
value=x.*coth(x/2)-4;




function[value]=coth(x)
value=1./tanh(x);



