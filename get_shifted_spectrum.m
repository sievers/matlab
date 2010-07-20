function[value]=get_shifted_spectrum(phase_lag,ell,scale,params,poly_sizes)
if (nargin<4)
    params=[ 20.136 0.42789 -9.2345 27.544 -1.8383 0.99806 -1.3506 -4.7777  12.982  0.56118 1.1043 -1.4838];
    poly_sizes=[ 3     2     3     2];
end
if (nargin<3)
    scale=1000;
end
use_params=params;
for j=max(size(phase_lag)):-1:1,
    use_params(2)=params(2)-phase_lag(j);
    if size(ell,1)>size(ell,2)
        value(:,j)=predict_ee(use_params,ell/scale,poly_sizes);
    else
        value(j,:)=predict_ee(use_params,ell/scale,poly_sizes);
    end
end
