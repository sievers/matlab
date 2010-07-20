function[data,freq]=read_wav(filename)
fid=fopen(filename);
fread(fid,5,'int32');
pcm_type=fread(fid,1,'int16');
if pcm_type ~= 1
    error('Unsupported PCM Type.');
end
num_channels=fread(fid,1,'int16');
freq=fread(fid,1,'int32');
fread(fid,1,'int32');
fread(fid,1,'int16');
BitsPerSample=fread(fid,1,'int16');
if BitsPerSample ~=8
    if BitsPerSample ~=16
        BitsPerSample
        error('BitsPerSample must be 8 or 16.');
    end
end
fread(fid,1,'int32');
chunk_size=fread(fid,1,'int32');
NumSamples=chunk_size/(num_channels*BitsPerSample/8);

if num_channels==1
  if BitsPerSample ==8
      data=fread(fid,[1,inf],'int8');
  else
      data=fread(fid,[1,inf],'int16');
  end
  if max(size(data))~=NumSamples
      NumSamples
      whos data
      warning('Warning - mistmatch between actual and expected number of samples.');
  end
else
    if BitsPerSample==8
        data=fread(fid,[2,inf],'int8');
    else
        data=fread(fid,[2,inf],'int16');
    end
    if max(size(data))~=NumSamples
        NumSamples
        whos data
        warning('Warning - mismatch between actual and expected number of samples.');
    end
end
data=data';
    
fclose(fid);