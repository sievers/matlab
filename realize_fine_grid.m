function[estmap]=realize_fine_grid(finemap,rgrid,ugood,vgood,pad)
padvec=(-pad:pad);
estmap(size(rgrid,3),1)=0;
for j=size(rgrid,3):-1:1,
    %whos
    estmap(j)=sum(sum(finemap(ugood(j)+padvec,vgood(j)+padvec).*rgrid(:,:,j)));
end


