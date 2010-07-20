function[pols]=pol_ind_from_names(pol_names)
npols=size(pol_names,1);
for j=1:npols,
    switch lower(pol_names(j,:))
        case {'tt'}
            pols(j)=1;
        case {'ee'}
            pols(j)=2;
        case {'bb'}
            pols(j)=3;
        case {'eb'}
            pols(j)=4;
        case {'te'}
            pols(j)=5;
        case {'tb'}
            pols(j)=6;
        otherwise
            warning(['Requested Unknown Polarization:  ' pol_names(j,:)]);
            pols(j)=0;
    end
end