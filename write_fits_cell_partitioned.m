function[value]=write_fits_cell_partitioned(fname,map,keys,values,varargin)
%write out a partitioned map.  Do so by sending in all the bits to the master
myid=mpi_comm_rank+1;
nproc=mpi_comm_size;


bitpix=get_keyval_val('BITPIX',keys,values);
if isempty(bitpix)
  bitpix=-64;
  [keys,values]=set_keyval_val('BITPIX',bitpix,keys,values);
end


naxis=get_keyval_val('NAXIS',keys,values);
if isempty(naxis),
  [keys,values]=set_keyval_val('NAXIS',2,keys,values);
end



naxis1=get_keyval_val('NAXIS1',keys,values); if isempty(naxis1) naxis1=0;end; if ischar(naxis1), naxis1=str2num(naxis1); end;
naxis2=get_keyval_val('NAXIS2',keys,values);if isempty(naxis2) naxis1=0;end;  if ischar(naxis2), naxis2=str2num(naxis2); end;

%sz=[naxis1 naxis2];%
%
%strict=get_keyval_default('strict',false,varargin{:});
%
%if sz~=size(map)
%  if strict,
%    error('map size mismatch, with strict set to true.');
%  else
%    [keys,values]=set_keyval_val('NAXIS1',size(map,1),keys,values);
%    [keys,values]=set_keyval_val('NAXIS2',size(map,2),keys,values);
%  end
%end


if ischar(bitpix)
  bitpix=str2num(bitpix);
end

switch bitpix
  case {-64}
   precision='double';
  case {-32}
   precision='float';
 case {32}
  precision='int32';
 case {64}
  precision='int64';
 otherwise
  disp('unkown precision')
  return;
end

if (myid==1)
  fid=fopen(fname,'w','ieee-be');
  if (fid==-1)
    error(['unable to open ' fname ' for writing.']);
  end
end
nwritten=numel(map);
if myid==1
  write_fits_header_cell(fid,keys,values);
  fwrite(fid,map,precision);
else
  mpi_send(map,1);
end
if myid==1,
  for j=2:nproc,
    mm=mpi_recv(j);
    fwrite(fid,mm,precision);
    nwritten=nwritten+numel(mm);
  end
end

%nwritten=prod(size(map))*abs(bitpix)/8;
nwritten=nwritten*abs(bitpix/8);
nleft=2880-rem(nwritten,2880);
if (nleft==2880)
  nleft=0;
end

if (myid==1)
  for j=1:nleft,
    fprintf(fid,' ');
  end
  fclose(fid);
end



  

