function[value]=read_matrix(filename)
%reads a matrix in from disk from gridder output.  Will look for unzipped version, if it doesn't exist,
%will gunzip it.  Also, will look for tail, and try to figure out which reading thing to use to match
%the filename.

%first, check for file existence, and auto-gunzip it, if required.
fid=fopen(filename,'r');
if (fid==-1)
  fid=fopen([filename '.gz'],'r');
  if (fid==-1)
    error(['unable to find ' filename ' or ' filename '.gz.  Exiting read_matrix']);
  end
  fclose(fid);
  system(['gunzip ' filename '.gz']);
else
  fclose(fid);
end

ind=1:length(filename);
pos=max(ind(filename=='_'));
tail=filename(pos+1:length(filename));
disp(tail);
if (strcmp(tail,'NOIS'))
  value=read_split_noise(filename);
  return
end

crap={'EE';'TT';'TE';'EB';'TB';'BB'};

if (max(strcmp(tail,crap)))
  value=read_split_signal(filename);
  return;
end

if (max(strcmp(tail,{'CSRC';'PROJ'})))
  value=read_split_src(filename);
  return;
end

error(['Unrecognized suffix ' tail ' in filename ' filename '.']);
