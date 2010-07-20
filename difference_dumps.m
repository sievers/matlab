function[value]=difference_dumps(file_root1,file_root2,outfile_root)

do_noise=1;
do_rgrid=1;
do_source=1;
do_proj=0;
clean_noise=1;cut_thresh=3e-7;

do_full_write=1;

if (nargin<5)
    noise_facs=[1 1];
end

[s1,u1,v1,z1,psf1]=read_tt_dump_svec(file_root1);
[s2,u2,v2,z2,psf2]=read_tt_dump_svec(file_root2);

if ((sum(abs(u1-u2))~=0)|(sum(abs(v1-v2))~=0))
    error('Error - uv coordinate mismatch in difference_dumps.');
end
s=s1-s2;
u=u1;
v=v1;
z=z1+z2;
psf=psf1+psf2;
zz=reshape([z z]',[2*length(z) 1]);
write_tt_dump_svec(outfile_root,s,u,v,z,psf);

n=length(z)/2;
%disp(['ns from svecs are ' num2str([n1 n2])])
if (do_full_write)
    fname=[outfile_root '.data'];
    write_C_data(fname,s./zz,u,v,z);
    system(['rm -f ' fname '.gz; gzip ' fname]);
end
%whos s*
if (do_noise)
    noise1=read_tt_dump_noise(file_root1,0);
    noise2=read_tt_dump_noise(file_root2,0);
    noise1=noise1+noise2;
    clear noise2;
    whos noise1
    write_tt_dump_noise(outfile_root,noise1);
    clear noise1;
    %if (do_full_write)
    %    noise1=read_tt_dump_noise(file_root1,1)*noise_facs(1);
    %    if (clean_noise)
    %        disp('cleaning noise now.');
    %        [vv,ee]=eig(noise1);
    %        ee=diag(ee);
    %        cut=cut_thresh*max(ee);
    %        nclean=sum(ee<cut);
    %        disp(['cleaning out ' num2str(nclean) ' modes out of ' num2str(length(ee))]);
    %        ee(ee<cut)=cut;
    %        noise1=vv*diag(ee)*vv';
    %        clear ee
    %        clear vv;
    %    end
    %    
    %    noise2=read_tt_dump_noise(file_root2,1)*noise_facs(2);
    %    whos
    %    ind1=2*n1+1;
    %    ind2=2*(n1+n2);
    %    disp([ind1 ind2 (ind2-ind1+1)])
        
    %    noise1(ind1:ind2,ind1:ind2)=noise2;
    %    clear noise2;
    %    fname=[outfile_root '.noise'];
    %    write_single_mat(fname,noise1,0,5000);
     %   clear noise1;
     %   system(['rm -f ' fname '.gz; gzip ' fname]);
    %end
    
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

    rgrid1=rgrid1-rgrid2;
    clear rgrid2
    write_tt_dump_rgrid(outfile_root,rgrid1,du1,nbeam1);
    clear rgrid1
end


if (do_source)
    nsource1=how_many_files([file_root1 '_Dsrc_'],'.dmp');
    nsource2=how_many_files([file_root2 '_Dsrc_'],'.dmp');
    nsource=max([nsource1 nsource2])
    if (nsource>0)
        jmin=0;
        fid1=fopen([file_root1 '_Fsrc.dmp'],'r');
        fid2=fopen([file_root2 '_Fsrc.dmp'],'r');
        if (fid1==-1)
            jmin=1;
        else
            fclose(fid1);
        end
        if (fid2==-1)
            jmin=1;
        else
            fclose(fid2);
        end
        for j=jmin:nsource,
            disp(['processing source matrix ' num2str(j)]);
            [source_mat1,nsrc1,nest1,dist1]=read_tt_dump_sources(file_root1,j);
            [source_mat2,nsrc2,nest2,dist2]=read_tt_dump_sources(file_root2,j);
            if (nsrc1~=nsrc2)
                error(['Mismatch in number of sources in ' file_root1 ' and ' file_root2]);
            end
            dist=min([dist1 dist2]')';

            source_mat1=source_mat1-source_mat2;
            
            disp(['writing source dump ' num2str(j)]);
            clear source_mat2
            write_tt_dump_sources(outfile_root,source_mat1,j,dist);
            zz_use=zz;zz_use(zz_use==0)=1;
            if (do_full_write)&(j>0) %don't write the Fsrc matrix
                fname=[outfile_root '.source_' num2str(j-1)];
                for k=1:size(source_mat1,2),
                    source_mat1(:,k)=source_mat1(:,k)./zz_use;
                end
                mat=source_mat1*source_mat1';
                clear source_mat1;
                write_single_mat(fname,mat,0,5000);
                clear mat;
                system(['rm -f ' fname '.gz; gzip ' fname]);
                
            end

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
