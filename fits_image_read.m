function[data,header,name_list]=fits_image_read(file_name,header_only)
if ~exist('header_only')
    header_only=false;
end

fid=fopen(file_name);
finished=0;
head_line=0;
names(500,8)=' ';
values(500,72)=' ';
while finished==0
    head_str=fgets(fid,80);
    if head_str(1:4)=='END '
        finished=1;
    else
        head_line=head_line+1;
        blob=sscanf(head_str(1:8),'%s');
        
        if max(size(blob)>0)
            names(head_line,1:max(size(blob)))=blob;
        end
        
        end_val=80;
        if head_str(9)=='='
            start_val=10;
        else
            start_val=9;
        end
        
        for j=80:-1:start_val,
            if (head_str(j)=='/')
                end_val=j-1;
            end
        end
        values(head_line,1:end_val-start_val+1)=head_str(start_val:end_val);
    end
end
nhead_block=ceil(80*(head_line+1)/2880);
nhead_block;
    
names(1:head_line,:);
header=values(1:head_line,:);

if (header_only)
    data=[];
    name_list=names(1:head_line,:);
    return;
end

   

obj=get_keyword_string('OBJECT',names,header);
xdim=get_keyword('NAXIS1',names,header);
ydim=get_keyword('NAXIS2',names,header);
bits=get_keyword('BITPIX',names,header);
bzero=get_keyword('BZERO',names,header,0);
fclose(fid);
fid=fopen(file_name,'r','ieee-be');
fseek(fid,2880*nhead_block,-1);
if (bits==32)
    data=fread(fid,[xdim,ydim],'int32');
end
if (bits==-32)
    data=fread(fid,[xdim,ydim],'float32');
end
if (bits==64)
    data=fread(fid,[xdim,ydim],'int64');
end
if (bits==-64)
    data=fread(fid,[xdim,ydim],'double');
end
if (bits==16)
    data=fread(fid,[xdim,ydim],'int16');
end
data=data+bzero;
name_list=names(1:head_line,:);
fclose(fid);
