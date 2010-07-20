function[value]=write_simple_map(map,ra,dec,fname)
fid=fopen(fname,'w');
fwrite(fid,size(map,2),'int');
fwrite(fid,size(map,1),'int');
pixsize=dec(2)-dec(1);
fwrite(fid,pixsize,'float');
lims=[min(ra) max(ra) min(dec) max(dec)];
fwrite(fid,lims,'float');
fwrite(fid,map','float');
fclose(fid);


return

fid=fopen(fname,'w');
fwrite(fid,size(map,2),'int');
fwrite(fid,size(map,1),'int');
fwrite(fid,pixsize/60,'float');
ramin=180-size(map,2)/2*pixsize/60;  %pixsize in arcmin
ramax=180+size(map,2)/2*pixsize/60;  %pixsize in arcmin
decmax=size(map,1)/2*pixsize/60;
decmin=-1*decmax;
fwrite(fid,[ramin ramax decmin decmax ],'float');
fwrite(fid,map,'float');
fclose(fid);

