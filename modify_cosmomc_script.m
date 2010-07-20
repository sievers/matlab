function[value]=modify_cosmomc_script(inname,outname,keys,values)
%Replace a set of keys in script inname by values passed in and put in
%outname.  keys and values should both be cell arrays.

fid=fopen(inname,'r');
if (fid==-1)
    error(['Unable to find file ' inname]);
end
out_id=fopen(outname,'w');
if (out_id==-1)
    error(['Unable to find open ' outname ' for writing.']);
end


if (length(keys)~=length(values))
    error('Number of keys not the same as number of values.');
    fclose(fid);
    fclose(out_id);       
end


nkeys=length(keys);
for j=1:nkeys,
    keys{j}=strtrim(keys{j});
end
missing_list(1:nkeys)=true;

comment_str='#';
assign_str='=';

nline=0;
finished=0;
while (finished==0)    
    line_in=fgetl(fid);
    line_in_org=line_in;
    if (~isstr(line_in))  %we've hit the end of the file
        fclose(fid);
        fclose(out_id);
        for j=1:nkeys,
            if (missing_list(j))
                disp(['Did not find key ' keys{j} ' with value ' values{j} ' in file ' inname]);
            end
        end
        disp(['Input file had ' num2str(nline) ' lines.']);
        return
    end
    nline=nline+1;
    ind=1:length(line_in);
    ncomment=sum(line_in==comment_str);
    if (ncomment>0)
        ii=min(ind(line_in==comment_str));
        comment=line_in(ii:end);
        line_in=line_in(1:ii-1);
    else
        comment='';
    end
    if sum(line_in==assign_str)
        %We have an assignment statement.  Check it, and if we have a key
        %in our list, replace it.
        ii=min(ind(line_in==assign_str));
        key_in=line_in(1:ii-1);
        value_in=line_in(ii+1:end);
        key_in=strtrim(key_in);
        found_key=false;
        for j=1:nkeys,
            if strcmp(key_in,keys{j})
                %We found a key to be replaced.
                missing_list(j)=false;
                found_key=true;
                fprintf(out_id,'%s %s %s %s\n',key_in,assign_str,values{j},comment);
            end
        end
        if (~found_key)
            fprintf(out_id,'%s\n',line_in_org);
            %fprintf(out_id,'%s %s\n',line_in,comment);
        end
    
    else
        %Line appears to have nothing besides a comment.  Print it out,
        %move on...
        if length(line_in>0)
            fprintf(out_id,'%s %s\n',line_in,comment);
        else
            fprintf(out_id,'%s\n',comment);
        end
    end
end
    
        
    
            
    