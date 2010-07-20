function[ent,freqs]=entropy_good(vec)
if prod(size(vec))>length(vec),
    vec=reshape(vec,[prod(size(vec)) 1]);
end

vec=sort(round(vec));
vals=unique(vec);
freqs=zeros(length(vals),1);


freqs(1)=1;
n=length(vec);
ind=1;
for j=2:n,
    if (vec(j)~=vec(j-1))
        ind=ind+1;
    end
    freqs(ind)=freqs(ind)+1;
end

crap=freqs/sum(freqs);
ent=sum(-log2(crap).*crap);


