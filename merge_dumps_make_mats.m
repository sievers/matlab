function[value]=merge_dumps(file_root1,file_root2,outfile_root,source_combines)
%merge the dump files, make matrices that correspond to noise, projection,
%sources...  and set up a link to R and Svec so that you can recreate
%signal matrices without having to deal with extraneous crap.


do_noise=1;
do_rgrid=1;
do_source=1;
do_proj=1;

[s1,u1,v1,z1]=read_tt_dump_svec(file_root1);
[s2,u2,v2,z2]=read_tt_dump_svec(file_root2);
s=[s1' s2']';
u=[u1' u2']';
v=[v1' v2']';
z=[z1' z2']';
whos s
write_tt_dump_svec(outfile_root,s,u,v,z);
zz=reshape([z z]',[2*length(z) 1]);


%n1=size(noise1,2);
%n2=size(noise2,2);

n1=2*length(z1);
n2=2*length(z2);

if (do_noise)
    noise1=read_tt_dump_noise(file_root1,0);
    noise2=read_tt_dump_noise(file_root2,0);

    noise1([2*n1+1:2*(n1+n2)],n1+1:n1+n2)=noise2;
    clear noise2;
    whos noise1
    write_tt_dump_noise(outfile_root,noise1);
    clear noise1;
    noise1=read_tt_dump_noise(file_root1);
    noise2=read_tt_dump_noise(file_root2);
    noise1(n1+1:n1+n2,n1+1:n1+n2)=noise2;
    clear noise2;
    write_single_mat([outfile_root '_NOIS'],0,5000);
    clear noise1;

else
    clear noise1;
    clear noise2;
end


if (do_rgrid)
    [rgrid1,du1,nbeam1]=read_tt_dump_rgrid(file_root1,0);
    [rgrid2,du2,nbeam2]=read_tt_dump_rgrid(file_root2,0);

    if (nbeam1~=nbeam2)
        error(['mismatch in nbeams ' num2str([nbeam1 nbeam2])]);
    end
    if (du1~=du2)
        error(['mismatch in du''s ' num2str([du1 du2])]);
    end

    all_data=s./zz;
    write_split_data([outfile_root '_SVEC'],all_data,u*du1,v*du1,z);
    
    rgrid1(:,nbeam1*n1+1:nbeam1*(n1+n2))=rgrid2;
    clear rgrid2
    whos rgrid1
    write_tt_dump_rgrid(outfile_root,rgrid1,du1,nbeam1);
    clear rgrid1
end

n1=2*n1;
n2=2*n2;

if (do_source)
    nsource1=how_many_files([file_root1 '_Dsrc_'],'.dmp');
    nsource2=how_many_files([file_root2 '_Dsrc_'],'.dmp');
    nsource=max([nsource1 nsource2])
    if (nsource>0)
        if (nargin<4)
            source_combines(nsource)=0;
        else
            if (length(source_combines)<nsource)
                source_combines(nsource)=0;
            end
        end

        for j=1:nsource,
            [source_mat1,nsrc1]=read_tt_dump_sources(file_root1,j);
            [source_mat2,nsrc2]=read_tt_dump_sources(file_root2,j);
            whos source_mat*
            [nsrc1 nsrc2]


            if ((source_combines(j))&(nsrc1>0)&(nsrc2>0)&(nsrc1~=nsrc2))
                error(['Error - mismatch in numbers of sources with ' num2str([nsrc1 nsrc2])]);
            end
            if ((source_combines(j))|(nsrc2==0))
                source_mat1(n1+1:n1+n2,:)=source_mat2;
            else
                source_mat1(n1+1:n1+n2,nsrc1+1:nsrc1+nsrc2)=source_mat2;
            end
            whos source_mat1
            disp(['writing source dump ' num2str(j)]);
            clear source_mat2;
            write_tt_dump_sources(outfile_root,source_mat1,j);
            clear source_mat1
        end
    end
end
if (do_proj)
    
    nproj1=how_many_files([file_root1 '_Proj_'],'.dmp');
    nproj2=how_many_files([file_root2 '_Proj_'],'.dmp');
    nproj=max([nproj1 nproj2])
    if (nproj>0)
        for j=1:nproj,
            mat1=read_tt_dump_proj(file_root1,j);
            mat2=read_tt_dump_proj(file_root2,j);
            %np1=size(mat1,2);
            %np2=size(mat2,2);
            %[np1 np2]
            %[n1 n2]
            np1=n1/2;
            np2=n2/2;
            mat1(2*np1+1:2*(np1+np2),np1+1:np1+np2)=mat2;
            clear mat2;
            write_tt_dump_proj(outfile_root,mat1,j);
            clear mat1;
        end
    end
end
