function[map,ra,dec]=read_simple_map_from_template(fname,template)
[map,ra,dec]=read_simple_map(fname);
if ~exist('template')
    warning('no template given - returning full map');
    return
end

[map2,ra2,dec2]=read_simple_map(template);
clear map2;
sz1=dec(2)-dec(1);
sz2=dec2(2)-dec2(1);
if (abs(sz1-sz2)>1e-6*(abs(sz1)+abs(sz2)))
    error('pixel size mismatch in read_simple_map_from_template.');
end

[a,ra0]=min(abs(ra2(1)-ra));
[a,dec0]=min(abs(dec2(1)-dec));
nra=length(ra2);
ndec=length(dec2);

decind=dec0+(0:ndec-1);
raind=ra0+(0:nra-1);
map=map(decind,raind);
ra=ra(raind);
dec=dec(decind);


