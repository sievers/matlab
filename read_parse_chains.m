function[chains]=read_parse_chains(chain_root)

crud=read_chains(chain_root);
chains.omb=crud(:,2+1);
chains.omc=crud(:,2+2);
chains.theta=crud(:,2+3);
chains.tau=crud(:,2+4);
chains.ok=crud(:,2+5);
chains.asz=crud(:,2+8);
chains.ns=crud(:,2+9);
chains.as=crud(:,2+12);
chains.ol=crud(:,2+15);
chains.om=crud(:,2+17);
chains.s8=crud(:,2+18);
chains.h0=crud(:,2+21);
nelem=length(crud);
chains.dl_1(nelem,1)=0;
chains.dl_3(nelem,1)=0;
tic
for j=1:nelem,
    chains.dl_1(j)=get_dl(1.0,chains.h0(j),chains.om(j),chains.ok(j));
    chains.dl_3(j)=get_dl(3.0,chains.h0(j),chains.om(j),chains.ok(j));
end
toc