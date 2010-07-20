function[data,noise,sources,wins,u,v,z]=read_C_data_set(fileroot)
[data,u,v,z]=read_C_data([fileroot '.data']);
n=length(data);
noise=read_single_mat([fileroot '.noise']);
nsource=nfiles_in_set([fileroot '.source_']);
nproj=nfiles_in_set([fileroot '.proj_']);
sources(n,n,nsource+nproj)=0;
for j=1:nsource,
    sources(:,:,j)=read_single_mat([fileroot '.source_' num2str(j-1)]);
end
for j=1:nproj,
    sources(:,:,j+nsource)=read_single_mat([fileroot '.proj_' num2str(j-1)]);
end

if (nargout>3)
    nwin=nfiles_in_set([fileroot '.pol_TT_']);
    wins(n,n,nwin)=0;
    for j=1:nwin,
        wins(:,:,j)=read_single_mat([fileroot '.pol_TT_' num2str(j-1)]);
    end
end


