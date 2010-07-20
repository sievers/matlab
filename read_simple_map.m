function[map,ra,dec,n]=read_simple_map(fname,fmt)
if ~exist('fmt')
    fmt='float';
end

fid=fopen(fname,'r');
n=fread(fid,[1 2],'int');
pixsize=fread(fid,1,fmt);
lims=fread(fid,[1 4],fmt);
map=fread(fid,fliplr(n),fmt);
%map=fread(fid,(n),'float')';
fclose(fid);
if (nargout>1)
    ra=(0:n(1)-1)*pixsize+lims(1);
    dec=(0:n(2)-1)*pixsize+lims(3);
end


