function[value]=sizeof(dattype)
found=0;
switch lower(dattype)
    case {'double','double64'}
        value=8;
    case {'int','int32'}
        value=4;
    case {'char'}
        value=1;
    case {'float','float32'}
        value=4;
    otherwise
        disp(['Unknown datatype in sizeof: ' dattype]);
end
