function[value]=write_srccat(fname,src)
%Write out a source catalog given source info.  The structure should
%conform to the output of read_srccat.

fid=fopen(fname,'w');
if (fid==-1)
    error(['Unable to open ' fname ' for writing in write_srccat.']);
end

nsrc=length(src.ra);
if (length(src.dec)~=nsrc)
    error('RA and Dec size mismatch in write_srccat.');
end

if (~isfield(src,'freq'))
    src.freq(1:nsrc,1)=31;
end
if (~isfield(src,'names'))
    src.names{1:nsrc}='FOO';
end


for j=1:nsrc,
    [rah,ram,ras]=dd2dms(src.ra(j));
    [dd,dm,ds]=dd2dms(src.dec(j));
    rah(rah=='+')=' ';
    fprintf(fid,'%12s %s:%s:%s  %s:%s:%s   %5.3f %9.3f %8.3f\n',src.names{j},rah,ram,ras,dd,dm,ds,src.freq(j),src.flux(j),src.err(j));
end
fclose(fid);

    