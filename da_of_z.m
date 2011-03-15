function[value,z_tab]=da_of_z(z,h)
%generic interpolation for a standard cosmology:
% Omega_m=0.27, h=70, flat

z_tab=[0 0
    0.1 381.3
    0.2 683.6 
    0.3 924.8
    0.4 1117.8
    0.5 1272.4
    0.6 1396.1
    0.8 1572.9
    1.0 1682.2
    1.2 1746.0
    1.5 1786.5
    1.8 1786.6
    2.2 1752.6 
    3.0 1638.2 
    4.0 1481.8
    6.0 1220.2
    8.0 1030.5
    10   890.7
    13   740.0
    16   633.4
    20   531.7
    40   297.2
    70   180.2
    100  129.8
    200  67.543
    300  45.783
    500  27.908
    5000 2.877
    50000 0.289];
value=interp1(1+z_tab(:,1),z_tab(:,2).*(1+z_tab(:,1)),1+z,'*cubic');
%value=interp1(1+z_tab(:,1),z_tab(:,2).*(1+z_tab(:,1)),1+z,'spline');

value=value./(1+z);

if (nargin>1)
    value=value*70/h;
end
