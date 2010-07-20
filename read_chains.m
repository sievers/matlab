function[big_chain,big_n]=read_chains(root,cutfrac)
if ~exist('cutfrac')
    cutfrac=0.3;
end

cut_is_frac=false;
if (cutfrac>0) & (cutfrac<1)
    cut_is_frac=true;
end



big_chain=[];
nfiles=how_many_files([root '_'],'.txt',1);

for j=1:nfiles,
    chain_in=load([root '_' num2str(j) '.txt']);
    n=size(chain_in,1);
    if (cut_is_frac)
        n_start=ceil(n*cutfrac);
    else
        n_start=1+cutfrac;
    end
    big_n(j)=n-n_start+1;
    big_chain=[big_chain;chain_in(n_start:end,:)];
end
    