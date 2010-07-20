function[value]=merge_svecs(file1,file2,outfile,subtract_vec,fac)
[data1,u1,v1,z1,nl1,np1,ra1,dec1]=read_split_data(file1);
[data2,u2,v2,z2,nl2,np2,ra2,dec2]=read_split_data(file2);

data=[data1' data2']';
if exist('subtract_vec')
    data=data-subtract_vec;
end

if (exist('fac'))
    data=data*fac;
end

u=[u1' u2']';
v=[v1' v2']';
z=[z1' z2']';
nl=nl1+nl2;
np=np1+np2;
%write_data_vec(outfile,data,u,v,z);
tol=1e-6;
if (abs(ra1-ra2)>tol)
  dra=ra1-ra2;
  warning(['Warning - mismatch in RA: ' num2str(dra)]);
end
if (dec1~=dec2)
  ddec=dec1-dec2;
  warning(['Warning - mismatch in Dec: ' num2str(ddec)]);
end

write_split_data(outfile,data,u,v,z,nl,np,ra1,dec1);
disp([ra1 dec1 ra2 dec2 length(data1) length(data2)])
