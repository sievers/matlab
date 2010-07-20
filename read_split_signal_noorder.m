function[value]=read_split_signal_noorder(filename)
fid=fopen(filename,'r');
crap=read_next_group(fid,'int');
n=crap(1);
ntt=crap(2);
npol=crap(3);

crap=read_next_group(fid,'int');
whichpol=crap(1);
nband=crap(2);

bandmin=read_next_group(fid,'float');
bandmax=read_next_group(fid,'float');

%haven't finished this - nee

for j=1:n/2,
    for band=1:nband,
        ipt=read_next_group(fid,'int');
        %disp(num2str([j band ipt]));
        if (band==1)
            if (j/100==round(j/100))
                disp(num2str(ipt))
            end
            ipt_org=ipt;
        else
            if (ipt~=ipt_org)
                error(['mismatch in ipt - ' num2str(ipt) ' ' num2str(ipt_org)]);
            end
        end       
        line_in=read_next_group(fid,'double');
        line_in=read_next_group(fid,'double');
    end
end
fclose(fid);
