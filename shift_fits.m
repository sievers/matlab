function[value]=shift_fits(fname1,fname2,dra,ddec)
  fid=fopen(fname1,'r');
  
  read_header=0;
  found_ra=0;
  found_dec=0;
  row=0;
  while (read_header==0)
    row=row+1;
    head_str=fgets(fid,80);
    [tok1,head_str]=strtok(head_str);
    [tok,head_str]=strtok(head_str);
    [tok,head_str]=strtok(head_str);
    if (length(tok)>1)
      if (strcmp(tok(2:end),'RA'))
        ra_ind=row;
        %disp([' RA token ' num2str(row) ' is ' tok1 '.']);
        ra_tok=['CRVAL' tok1(length('CTYPE')+1)];
        found_ra=1;
      end
      if (strcmp(tok(2:end),'DEC'))
        dec_ind=row;
        %disp([' Dec token ' num2str(row) ' is ' tok1 '.']);
	dec_tok=['CRVAL' tok1(length('CTYPE')+1)];
        found_dec=1;
      end
    end

    if (found_ra)&(found_dec)
      read_header=1;
    end

    if (row>180)
      fclose(fid);
      error('could not find appropriate RA and Dec tokens.')
      %disp(['Going to be searching for ra ' ra_tok ' and dec ' dec_tok]);
      return;
    end
end

fclose(fid);
fid=fopen(fname1,'r');
outf=fopen(fname2,'w');
found_pos=0;
found_ra=0;
found_dec=0;
nrow=0;
while (found_pos==0)
  nrow=nrow+1;
  head_str=fgets(fid,80);
  line_in=head_str;
  [tok,head_str]=strtok(head_str);
  if (strcmp(tok,ra_tok))|(strcmp(tok,dec_tok))
    if (strcmp(tok,ra_tok))
      found_ra=1;
      [tok,head_str]=strtok(head_str);
      [val,head_str]=strtok(head_str);
      %[com,head_str]=strtok(head_str);
      com=head_str;
      len=length(val);
      val=str2num(val);
      val=val+dra;
      outstr=[ra_tok '  =      '  num2str(val,len) '  ' com];
      outstr(length(outstr)+1:80)=' ';
      outstr=outstr(1:80);
    else
      found_dec=1;
      [tok,head_str]=strtok(head_str);
      [val,head_str]=strtok(head_str);
      %[com,head_str]=strtok(head_str);
      com=head_str;
      len=length(val);
      val=str2num(val);
      val=val+ddec;
      outstr=[dec_tok '  =      '  num2str(val,len) '  ' com];
      outstr(length(outstr)+1:80)=' ';
      outstr=outstr(1:80);
    end
    if (found_dec)&(found_ra)
      found_pos=1;
    end
    fwrite(outf,outstr);
  else
    fwrite(outf,line_in);
  end    
end

%while (1)
%  c=fread(fid,1,'char');
%  if length(c)==1
%    fwrite(outf,c);
%  else
%    fclose(outf);
%    fclose(fid);
%    return;
%  end
%end

crud=fread(fid,[1 inf],'int');
fwrite(outf,crud,'int');
fclose(fid);
fclose(outf);



