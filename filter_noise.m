function[value]=filter_noise(file_root,cut_thresh,noise_scale)

[data,u,v,z]=read_split_data([file_root '_SVEC']);
[data2,u2,v2,z2]=read_tt_dump_svec([file_root '_dump']);
zz2=reshape([z2 z2]',[2*length(z2) 1]);
keep_ind=(zz2>0);
whos



noise=read_split_noise([file_root '_NOIS.gz']);
zz=reshape([z z]',[2*length(z) 1]);
n=length(noise);
[vv,ee]=eig(noise);
ee=diag(ee);
disp(['Eigenvalue range is ' num2str([min(ee) max(ee)])]);
cut=cut_thresh*max(ee);
nclean=sum(ee<cut);
disp(['cleaning out ' num2str(nclean) ' modes out of ' num2str(length(ee)) ' in base ' file_root]);
ind=ee<cut;
ee(ee<cut)=cut;
if (exist('noise_scale'))
    disp(['Scaling noise by ' num2str(noise_scale) '.']);
    ee=ee*noise_scale;
end

noise=vv*diag(ee)*vv';
vv_cut=vv(:,ind);
%clear ee
%clear vv;
if (nclean)>0
  n2=length(data2);
  vv_use(n2,nclean)=0;
  vv_use(keep_ind,:)=vv_cut;
  zz_use=zz2;
  zz_use(zz2==0)=1;

  for j=1:size(vv_use,2),
    vv_use(:,j)=vv_use(:,j)./zz_use;
  end

  write_tt_dump_sources([file_root '_noisechop_' num2str(cut_thresh)],vv_use,1,zeros(size(vv_use,2)));

  fname=[file_root '_noise_filt_' num2str(cut_thresh) '.noise'];
  write_single_mat(fname,noise,0,5000);
  system(['gzip ' fname]);

  clear vv_use;            
end


  whos
end

%            
%            if (nclean>0)&(nclean2>0)
%                disp('merging vv_cut1 and vv_cut2');
%                vv_cut1(nnoise1+1:nnoise1+nnoise2,nclean+1:nclean+nclean2)=vv_cut2;
%            else
%                %OK, either nclean or nclean2 is zero, 
%                if (nclean>0)
%                    vv_cut1(nnoise1+nnoise2,1)=0;
%                else
%                    vv_cut1(nnoise1+1:nnoise1+nnoise2,:)=vv_cut2;
%                end
%            end
%            clear vv_cut2;
%            vv_use(length(zz),size(vv_cut1,2))=0;
%            vv_use(zz>0,:)=vv_cut1;
%            clear vv_cut1;
%            
%            zz_use=zz;
%            zz_use(zz==0)=1;
%           
%            for j=1:size(vv_use,2),
%                vv_use(:,j)=vv_use(:,j)./zz_use;
%            end
%            write_tt_dump_sources([outfile_root '_noisechop_' num2str(cut_thresh)],vv_use,1,zeros(size(vv_use,2)));
%            clear vv_use;
%            
%        end
%        whos
%        %ind1=2*n1+1;
%        %ind2=2*(n1+n2);
%        ind1=nnoise1+1;
%        ind2=nnoise1+nnoise2;
%        disp([ind1 ind2 (ind2-ind1+1)])
%
%        noise1(ind1:ind2,ind1:ind2)=noise2;
%        clear noise2;
%        if (clean_noise)|(clean_noise2)
%            fname=[outfile_root '_noise_filt_' num2str(cut_thresh) '.noise'];
%        else
%            fname=[outfile_root '.noise'];
%        end
%        %write_single_mat(fname,noise1(zz>0,zz>0),0,5000);
%        write_single_mat(fname,noise1,0,5000);
%        clear noise1;
%        system(['rm -f ' fname '.gz; gzip ' fname]);
%    end
%    
%else
%    clear noise1;
%    clear noise2;
%end
%
%
%if (do_rgrid)
%    [rgrid1,du1,nbeam1]=read_tt_dump_rgrid(file_root1,0);
%    [rgrid2,du2,nbeam2]=read_tt_dump_rgrid(file_root2,0);
%    if (nbeam1~=nbeam2)
%        error(['mismatch in nbeams ' num2str([nbeam1 nbeam2])]);
%    end
%    if (du1~=du2)
%        error(['mismatch in du''s ' num2str([du1 du2])]);
%    end
%
%    rgrid1(:,nbeam1*n1+1:nbeam1*(n1+n2))=rgrid2;
%    clear rgrid2
%    whos rgrid1
%    write_tt_dump_rgrid(outfile_root,rgrid1,du1,nbeam1);
%    clear rgrid1
%end
%
%n1=2*n1;
%n2=2*n2;
%
%if (do_source)
%    nsource1=how_many_files([file_root1 '_Dsrc_'],'.dmp');
%    nsource2=how_many_files([file_root2 '_Dsrc_'],'.dmp');
%    nsource=max([nsource1 nsource2])
%    if (nsource>0)
%        if (nargin<4)
%            source_combines(nsource)=0;
%        else
%            if (length(source_combines)<nsource)
%                source_combines(nsource)=0;
%            end
%        end
%        jmin=0;
%        fid1=fopen([file_root1 '_Fsrc.dmp'],'r');
%        fid2=fopen([file_root2 '_Fsrc.dmp'],'r');
%        if (fid1==-1)
%            jmin=1;
%        else
%            fclose(fid1);
%        end
%        if (fid2==-1)
%            jmin=1;
%        else
%            fclose(fid2);
%        end
%        for j=jmin:nsource,
%            disp(['processing source matrix ' num2str(j)]);
%            [source_mat1,nsrc1,nest1,dist1]=read_tt_dump_sources(file_root1,j);
%            [source_mat2,nsrc2,nest2,dist2]=read_tt_dump_sources(file_root2,j);
%            %whos source_mat*
%            %[nsrc1 nsrc2]
%            
%
%            if (j==0)
%                src_combine=1;
%            else
%                src_combine=source_combines(j);
%            end
%            if ((src_combine)&(nsrc1>0)&(nsrc2>0)&(nsrc1~=nsrc2))
%                error(['Error - mismatch in numbers of sources with ' num2str([nsrc1 nsrc2])]);
%            end
%            clear dist
%            if (~src_combine)
%                dist=[dist1;dist2];
%            else
%                dist=min([dist1 dist2]')';
%            end
%            %whos dis*
%
%            %if ((source_combines(j))|(nsrc2==0))
%            if ((src_combine)|(nsrc2==0))
%                source_mat1(n1+1:n1+n2,:)=source_mat2;
%            else
%                source_mat1(n1+1:n1+n2,nsrc1+1:nsrc1+nsrc2)=source_mat2;
%            end
%            whos source_mat1
%            disp(['writing source dump ' num2str(j)]);
%            clear source_mat2;
%            write_tt_dump_sources(outfile_root,source_mat1,j,dist);
%            if (do_full_write)&(j>0) %don't write the Fsrc matrix
%                fname=[outfile_root '.source_' num2str(j-1)];
%                for k=1:size(source_mat1,2),
%                    source_mat1(:,k)=source_mat1(:,k)./zz;
%                end
%                mat=source_mat1*source_mat1';
%                clear source_mat1;
%                write_single_mat(fname,mat,0,5000);
%                clear mat;
%                system(['rm -f ' fname '.gz; gzip ' fname]);
%                
%            end
%
%            clear source_mat1
%
%        end
%        
%        
%    end
%end
%if (do_proj)
%    
%    nproj1=how_many_files([file_root1 '_Proj_'],'.dmp');
%    nproj2=how_many_files([file_root2 '_Proj_'],'.dmp');
%    nproj=max([nproj1 nproj2])
%    if (nproj>0)
%        for j=1:nproj,
%            mat1=read_tt_dump_proj(file_root1,j);
%            mat2=read_tt_dump_proj(file_root2,j);
%            %np1=size(mat1,2);
%            %np2=size(mat2,2);
%            %[np1 np2]
%            %[n1 n2]
%            np1=n1/2;
%            np2=n2/2;
%            mat1(2*np1+1:2*(np1+np2),np1+1:np1+np2)=mat2;
%            clear mat2;
%            write_tt_dump_proj(outfile_root,mat1,j);
%            clear mat1;
%        end
%    end
%end
