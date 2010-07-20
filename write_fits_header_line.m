function[errcode]=write_fits_header_line(fid,name,value,strtype)
%do_str=0;
%if (nargin>3)
%    if (strtype)
%        do_str=1;
%    end
%end

if (ischar(value))
    do_str=1;
else
    do_str=0;
end
%if do_str
%    if value(1)~=''''
%        value=['''' value ''''];
%    end
%end



name_len=max(size(name));
errcode=0;
if (name_len>8)
    errcode=1;
    fprintf(1,'WARNING - name %s too long.  Truncating...\n',name);
    name=name(1:8);
    name_len=8;
end

spacechar=char(32);


%pad name string with zeros to make it 8 characters long
if name(1:3)=='END',
    fwrite(fid,name,'char');
    for j=4:80,
        fwrite(fid,spacechar,'char');
    end
else
    name(int16(name)==0)=spacechar;

    for (j=1:name_len),
        fwrite(fid,name(j),'char');
    end
    for (j=name_len+1:8),
        fwrite(fid,spacechar,'char');
    end


    if do_str==0
        fwrite(fid,['=' spacechar],'char');
        if floor(value)==ceil(value)
            val_str=sprintf('%18d',value);
        else
            val_str=sprintf('%18.8g',value);
        end
        fwrite(fid,val_str,'char');
        for j=29:80,
            fwrite(fid,' ','char');
        end
    else
        %value=sprintf('%s',value);
        value(int16(value)==0)=spacechar;
        if max(size(value))==7200,
            fwrite(fid,value,'char');
        else
            fwrite(fid,['=' spacechar],'char');
            %fwrite(fid,value,'char');
            if length(value)<70
                for j=length(value)+1:70,
                    value(j)=spacechar;
                end
            end
            fwrite(fid,value(1:70),'char');
            %for j=11+max(size(value)):80,
            %    fwrite(fid,' ','char');
            %end
        end
    end
end




