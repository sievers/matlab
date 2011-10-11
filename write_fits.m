function[value]=write_fits(data,file_name,names,values)
nlines=0;
fid=fopen(file_name,'w','ieee-be');
for j=1:size(names,1),
    write_fits_header_line(fid,names(j,:),values(j,:),1);
    nlines=nlines+1;
end
write_fits_header_line(fid,'END',' ');
nlines=nlines+1;
nhead_block=ceil(nlines*80/2880);
zero_pad(fid,2880*nhead_block-80*nlines);
%fwrite(fid,data,'float32');
fwrite(fid,data,'double');
nbit=size(data,1)*size(data,2)*8;
to_pad= ceil((ceil(nbit/2880)-nbit/2880)*2880-0.5);
zero_pad(fid,to_pad);
fclose(fid);
