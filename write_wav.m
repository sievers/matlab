function[value]=write_wav(data,file_name,SampleRate,BitsPerSample)
if (nargin<4)
    BitsPerSample=16;
end
if (nargin<3)
    SampleRate=44100;
end
if BitsPerSample ~=8,
    if BitsPerSample ~= 16,
        BitsPerSample
        error('Error - BitsPerSample must be 8 or 16');
    end
end
fid=fopen(file_name,'w');
fprintf(fid,'RIFF');
NumSamples=max(size(data))
NumChannels=min(size(data))
int_to_write=round(36+NumSamples*NumChannels*(BitsPerSample/8));
fwrite(fid,int_to_write,'int32');
fprintf(fid,'WAVE');
fprintf(fid,'fmt ');
int_to_write=16;
fwrite(fid,int_to_write,'int32');

int_to_write=1;
fwrite(fid,int_to_write,'int16');
fwrite(fid,NumChannels,'int16');
fwrite(fid,round(SampleRate),'int32');
data_rate=SampleRate*NumChannels*BitsPerSample/8;
fwrite(fid,data_rate,'int32');
bytes_per_sample=NumChannels*BitsPerSample/8;
fwrite(fid,bytes_per_sample,'int16');
fwrite(fid,BitsPerSample,'int16');

fprintf(fid,'data');
chunk_size=round(NumSamples*NumChannels*BitsPerSample/8);
fwrite(fid,chunk_size,'int32');

minval=min(min(data));
maxval=max(max(data));
if (BitsPerSample==8)
    data=10+round(235* (data-minval)/(maxval-minval));
    if size(data,1)<size(data,2),
        fwrite(fid,data,'int8');
    else
        fwrite(fid,data','int8');
    end
else
%    data=-30000+round(60000*(data-minval)/(maxval-minval));
    if (size(data,1)<size(data,2)),
        fwrite(fid,data,'int16');
    else
        fwrite(fid,data','int16');
    end
end

    
fclose(fid);