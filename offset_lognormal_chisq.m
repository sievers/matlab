function[value,dx]=offset_lognormal_chisq(targ,data,errs,otherps)
%calculate chi^2 for a target dataset given data, errs, and (optionally)
%otherps.  If errs are diagonal
if (~exist('errs'))
    errs=ones(length(data));
end
if length(errs)==0
    errs=ones(length(data));
end

if length(errs)==1,
    errs=errs^2*ones(length(data));
end
if length(errs)~=length(data)
    error('size mismatch between errs and data in offset_lognormal_chisq');
end

if min(size(errs))==1
    errs=diag(errs.^2);
end

if size(data,1)==1
    data=data';
end


if size(targ,1)~=length(data)
    targ=targ';
end


if size(targ,1)~=length(data)
    error('Data and target size mismatch in offset_lognormal_chisq');
end


if (exist('otherps')),
    vec=data+otherps;
    errsinv=diag(vec)*inv(errs)*diag(vec);
    targ=log(targ+repmat(otherps,[1 size(targ,2)]));
    data=log(data+otherps);
else
    errsinv=inv(errs);
end

dx=targ-repmat(data,[1 size(targ,2)]);
for j=1:size(dx,2),
    value(j,1)=(dx(:,j)'*errsinv*dx(:,j));
end
%value=diag(dx'*errsinv*dx);

for j=1:length(value),
    if (~isreal(value(j)))
        value(j)=1e6;
    end
end




    