function[u,v,rr,ii,wt]=read_js(filename)
fid=fopen(filename,'r');
if (fid==-1)
    error(['unable to open ' filename ' in read_js']);
end
crap=fgetl(fid);

finished=0;
nvis=0;
while (finished==0)
    line_in=fgetl(fid);
    if (length(line_in)<2)
        return;
    end
    crud=sscanf(line_in,'%f');
    uu=crud(4);
    vv=crud(5);
    

    for j=1:10,
        line_in=fgetl(fid);
        crud=sscanf(line_in,'%f');
        nvis=nvis+1;
        freq=(36.5-j);
        fac=freq/30;
        u(nvis,1)=uu*fac;
        v(nvis,1)=vv*fac;
        rr(nvis,1)=crud(2);
        ii(nvis,1)=crud(4);
        wt(nvis,1)=crud(1);
    end
end

           
