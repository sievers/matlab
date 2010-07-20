function[sz]=read_sz_templates(fname)
fid=fopen(fname,'r');
crud=fscanf(fid,'%f',[3 1]);
nrow=crud(1);
freq=crud(2);
ombh=crud(3);
s8=fscanf(fid,'%f',[1 nrow]);
mat=(fscanf(fid,'%f',[nrow+1 inf]))';
ell=mat(:,1);
amps=mat(:,2:end);
sz.n=nrow;
sz.ombh=ombh;
sz.ell=ell;
sz.amps=amps;
sz.s8=s8;


fclose(fid);
