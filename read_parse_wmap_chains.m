function[chains]=read_parse_wmap_chains(chain_root)
crap=load([chain_root '/omegabh2']);
chains.omb=crap(:,2);

crap=load([chain_root '/omegach2']);
chains.omc=crap(:,2);

crap=load([chain_root '/thetastar']);
chains.theta=crap(:,2);

crap=load([chain_root '/tau']);
chains.tau=crap(:,2);

try
    crap=load([chain_root '/omegak']);
catch 
    crap(:,2)=0;
end
chains.ok=crap(:,2);


crap=load([chain_root '/asz']);
chains.asz=crap(:,2);

crap=load([chain_root '/ns002']);
chains.ns=crap(:,2);

crap=load([chain_root '/a002']);
chains.as=crap(:,2);

crap=load([chain_root '/omegal']);
chains.ol=crap(:,2);

crap=load([chain_root '/omegam']);
chains.om=crap(:,2);

crap=load([chain_root '/sigma8']);
chains.s8=crap(:,2);

crap=load([chain_root '/H0']);
chains.h0=crap(:,2);


nelem=length(chains.h0);

tic
zmin=0.1;frac=0.05;zmax=20;z=exp(log(zmin):log(1+frac):log(zmax*(1+frac)));z=[0.005:0.005:zmin z];
chains.z=z;

mat(length(z),nelem)=0;
for j=1:nelem
    mat(:,j)=get_dl_vec(z,chains.h0(j),chains.om(j),chains.ok(j));
end
toc
chains.z=z;
chains.mat=mat;



%chains.dl_1(nelem,1)=0;
%chains.dl_3(nelem,1)=0;
%tic
%for j=1:nelem,
%    chains.dl_1(j)=get_dl(1.0,chains.h0(j),chains.om(j),chains.ok(j));
%    chains.dl_3(j)=get_dl(3.0,chains.h0(j),chains.om(j),chains.ok(j));
%end
%toc