function[value]=zero_pad(fid,nzero)
for j=1:nzero,
    fwrite(fid,' ','char');
end
