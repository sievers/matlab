function[value]=read_srccat(varargin)
if isnumeric(varargin{end}),
  colset=varargin{end};
  varargin=varargin(1:end-1);
else
  colset=1;
end

if length(colset)>1,
  varargin_use=varargin;
  varargin_use{end+1}=colset(1);

  bigcat=read_srccat(varargin_use{:});
  for j=2:length(colset),
    varargin_use{end}=colset(j);
    cat2=read_srccat(varargin_use{:});
    disp('hi');
    eval(['bigcat.flux' num2str(j) ' = cat2.flux;']);
    eval(['bigcat.freq' num2str(j) ' = cat2.freq;']);
    eval(['bigcat.err' num2str(j) ' = cat2.err;']);
  end
  value=bigcat;
  return
end

    


nfile=length(varargin);
value=read_one_srccat(varargin{1},colset);
for j=2:nfile,
    crap=read_one_srccat(varargin{j});
    value.ra=[value.ra;crap.ra];
    value.dec=[value.dec;crap.dec];
    value.flux=[value.flux;crap.flux];
    value.err=[value.err;crap.err];
    value.freq=[value.freq;crap.freq];
    %whos
    %crap
    value.names=[value.names crap.names];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[value]=read_one_srccat(fname,colset)
if ~exist('colset')
  colset=1;
end

nl=file_nlines(fname);
if (nl==-1)
    warning([fname ' does not exist in read_srccat.']);
    return
end
if (nl==0)
    warning([fname ' appears to be empty in read_srccat.']);
    return
end

ra(nl,1)=0;
dec(nl,1)=0;
flux(nl,1)=0;
err(nl,1)=0;
freq(nl,1)=0;
names{nl}=0;
nsrc=0;
fid=fopen(fname,'r');
while (1)
    linein=fgetl(fid);
    if (~ischar(linein)), break,end
    startpos=1;
    while (linein(startpos)==' ')
        startpos=startpos+1;
    end
    if (linein(startpos)~='!')
        nsrc=nsrc+1;
        linein(linein==':')=' ';
        [ra(nsrc),dec(nsrc),flux(nsrc),err(nsrc),names{nsrc},freq(nsrc)]=process_line(linein,colset);
        
        %[value(nsrc).ra,value(nsrc).dec,value(nsrc).flux,value(nsrc).err]=process_line(linein);        
    end
end
fclose(fid);
ra=ra(1:nsrc);
dec=dec(1:nsrc);
flux=flux(1:nsrc);
err=err(1:nsrc);
freq=freq(1:nsrc);
names=names(1:nsrc);
value.names=names;
value.ra=ra;
value.dec=dec;
value.flux=flux;
value.err=err;
value.freq=freq;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[ra,dec,flux,err,name,freq]=process_line(str,colset)
[name,str]=strtok(str);
[rah,str]=strtok(str);
[ram,str]=strtok(str);
[ras,str]=strtok(str);
[dd,str]=strtok(str);
[dm,str]=strtok(str);
[ds,str]=strtok(str);
for j=1:colset-1,
  [crap,str]=strtok(str);
  [crap,str]=strtok(str);
  [crap,str]=strtok(str);
end
[freq,str]=strtok(str);
[flux,str]=strtok(str);
[err,str]=strtok(str);

ra=str2num(rah)+str2num(ram)/60+str2num(ras)/3600;
sgn=max(dd=='-');sgn=-2*sgn+1;dd(dd=='-')=' ';
dec=(str2num(dd)+str2num(dm)/60+str2num(ds)/3600)*sgn;
flux=str2num(flux);
err=str2num(err);
freq=str2num(freq);
