function[smoothed_data]=smooth_data(data,width,order)
coeffs=get_savgol_coeffs_alldata(width,order);

smoothed_data=data;
%only smooth data in the middle
for j=width+1:max(size(data))-width-1,
    params=coeffs*data(j-width:j+width);
    smoothed_data(j)=params(1);
end
