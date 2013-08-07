function[keysvals,xtvals]=simple_write_healpix(fname,map,weights,ringnest)
if ~exist('ringnest')
  ringnest='ring';
end

if (strcmp(ringnest,'ring'))
  tag='''RING''';
else
  tag='''NESTED''';
end


keysvals={
'SIMPLE'  'T'   
'BITPIX'  16
'NAXIS'    0
'EXTEND'  'T'
'RESOLUTN'  9
'PIXTYPE'  '''HEALPIX'''
'ORDERING'  tag
'NSIDE'      512
'FIRSTPIX'    0
'LASTPIX'   3145727
};

xtvals={
'XTENSION' '''BINTABLE'''           
'BITPIX'                      8 
'NAXIS'                       2 
'NAXIS1'                      4
'NAXIS2'                3145728 
'PCOUNT'                      0 
'GCOUNT'                      1 
'TFIELDS'                     1 
'TTYPE1'   '''TEMPERATURE '''       
'TFORM1'   '''E       '''           
'TUNIT1'   '''K      '''           
'EXTNAME'  '''Archive Map Table'''  
'PIXTYPE'  '''HEALPIX '''           
'COORDSYS'                 ' ''unknown '''
'ORDERING' tag
'NSIDE'                     512 
'FIRSTPIX'                    0 
'LASTPIX'               3145727 
};
do_weight=false;
if exist('weights')
  if ~isempty(weights)
    do_weight=true;
    assert(min(size(weights)==size(map))==1);
    crud={
        'TTYPE2'  '''N_OBS   '''           
        'TFORM2'  '''E       '''           
        'TUNIT2'  '''counts  '''           
         };
    xtvals=[xtvals;crud];
    xtvals=set_keysvals(xtvals,'NAXIS1',8,'TFIELDS',2);
  end
end

npix=numel(map);
nside=sqrt(npix/12);
res=log2(nside);
assert(res==round(res)); %better be an actual resolution
lastpix=12*4^res-1;  assert(numel(map)==lastpix+1);

keysvals=set_keysvals(keysvals,'RESOLUTN',res,'NSIDE',nside,'LASTPIX',lastpix);
xtvals=set_keysvals(xtvals,'NSIDE',nside,'LASTPIX',lastpix,'NAXIS2',lastpix+1);


fid=fopen(fname,'w','ieee-be');
write_fits_header_cell(fid,keysvals(:,1),keysvals(:,2));
write_fits_header_cell(fid,xtvals(:,1),xtvals(:,2));
if (do_weight)
  if size(map,1)==1,
    fwrite(fid,[map;weights],'float');
  else
    fwrite(fid,[map weights]','float');
  end
  nwrote=4*2*numel(map);
else
  fwrite(fid,map,'float');
  nwrote=4*numel(map);
end
frac=nwrote/2880;frac=frac-floor(frac);
if frac>0,
  nextra=round(2880-2880*frac);
  fprintf(fid,'%s',repmat(' ',[1 nextra]));
end
fclose(fid);

return

function[keyvals]=set_keysvals(keyvals,varargin)
keys=varargin(1:2:end);
vals=varargin(2:2:end);
for j=1:length(keys),
  for k=1:size(keyvals,1),
    if strcmp(keys{j},keyvals{k,1})
      keyvals(k,2)=vals(j);
    end
  end
end
