function[value]=read_margestats(fname)
fid=fopen(fname,'r');


if (fid==-1)
    error(['File ' fname ' missing in read_margestats.']);
end

line_in=fgetl(fid);

while (1)
    line_in=fgetl(fid);
    vals=sscanf(line_in,'%f');
    if (length(vals)>1)
        ind=round(vals(1));
        means(ind)=vals(2);
        stds(ind)=vals(3);
        low1(ind)=vals(4);
        up1(ind)=vals(5);
        low2(ind)=vals(6);
        up2(ind)=vals(7);
        inds(ind)=ind;
        for j=1:length(vals),
            [crap,line_in]=strtok(line_in);
        end
        names{ind}=line_in;
    else
        fclose(fid);
        value.inds=inds;
        value.vals=means;
        value.errs=stds;
        value.low1=means-low1;
        value.up1=up1-means;
        value.low2=means-low2;
        value.up2=up2-means;
        value.names=names;
        return;
    end
end

