function[data,errs,ell,otherps,big_curve,wins]=read_newdat_one_pol(filename,pol_name,windowroot)

[data,errs,ell,bands_in,which_pols,otherps,corrs,big_curve,errs_upper]=read_newdat(filename);


%whos which_pols
%which_pols
%whos bands

which_pol_nums=pol_ind_from_names(which_pols);
bands(1:6)=0;
for j=1:length(which_pol_nums),
    bands(which_pol_nums(j))=bands_in(j);
end
switch lower(pol_name)
    case {'tt'}
        pol=1;
    case {'ee'}
        pol=2;
    case {'bb'}
        pol=3;
    case {'eb'}
        pol=4;
    case {'te'}
        pol=5;
    case {'tb'}
        pol=6;
    otherwise
        error(['Requested Unknown Polarization:  ' pol_name]);
end
if (pol==1)
    n_to_skip=0;
else
    n_to_skip=sum(bands(1:(pol-1)));
end

for j=1:size(which_pols,1),
    if (lower(pol_name)==lower(which_pols(j,:)))
        j_use=j;
        data=data(1:bands_in(j),j);
        errs=errs(1:bands_in(j),j);
        otherps=otherps(1:bands_in(j),j);
        ell=ell(1:bands_in(j),j);
        big_curve=big_curve((n_to_skip+1):(n_to_skip+bands_in(j)),(n_to_skip+1):(n_to_skip+bands_in(j)));
    end
end
if (nargin>2)
    for j=bands_in(j_use):-1:1,
        wins_in=load([windowroot num2str(j+n_to_skip)]);
        wins(:,:,j)=wins_in;
    end
end



