function[fine_wins,wins,ell]=create_windows(base)
[data,errs,ell,bands,which_pols]=read_newdat(sprintf('%s.newdat',base));
raw_windows=load(sprintf('%s.windows',base));
nwin=size(raw_windows,1)/4;
dl=25;
lmin=100;
npol=4;

ell=lmin+dl*((1:nwin)-0.5);
for j=1:npol,
    wins(:,:,j)=raw_windows(  (1+nwin*(j-1)):nwin*j,:);
end
ell_fine=1:(dl+round(max(ell)));
for k=npol:-1:1,
    for j=size(wins,2):-1:1,
        fine_wins(:,j,k)=interp1(ell,wins(:,j,k),ell_fine,'spline');
    end
end
fine_wins=fine_wins/dl;
