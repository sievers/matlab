function[value]=simple_write_fits(data,file_name,dattype)
nlines=0;
if (nargin<3)
    dattype='f'; %for float
end

if (dattype(1)=='d')|(dattype(1)=='D')
    bitpix=-64;
    nbyte=8;
    str='double';
end
if (dattype(1)=='i')|(dattype(1)=='I')
    bitpix=32;
    nbyte=4;
    str='int32';
end
if (dattype(1)=='f')|(dattype(1)=='F')
    bitpix=-32;
    nbyte=4;
    str='float32';
end


fid=fopen(file_name,'w','ieee-be');
write_fits_header_line(fid,'SIMPLE','T',1);
%write_fits_header_line(fid,'BITPIX',-32);
write_fits_header_line(fid,'BITPIX',bitpix);
write_fits_header_line(fid,'NAXIS',2);
write_fits_header_line(fid,'NAXIS1',size(data,1));
write_fits_header_line(fid,'NAXIS2',size(data,2));
write_fits_header_line(fid,'BZERO',0);
write_fits_header_line(fid,'BSCALE',1);
%write_fits_header_line(fid,'DATAMIN',min(min(data)));
%write_fits_header_line(fid,'DATAMAX',max(max(data)));
write_fits_header_line(fid,'END',' ');
nlines=8;
zero_pad(fid,2880-nlines*80);

%fwrite(fid,data,'float32');
%nbit=size(data,1)*size(data,2)*4;
fwrite(fid,data,str);
nbit=size(data,1)*size(data,2)*nbyte;



to_pad= ceil((ceil(nbit/2880)-nbit/2880)*2880-0.5);
zero_pad(fid,to_pad);
fclose(fid);

