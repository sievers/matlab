function[mat,vec,u_int,v_int]=est2grid(u,v,dat,du,umax)


if (nargin<4)   
    du=25.5777;
    %du=10.6574 for pol mosaics
end
u_int=round(u/du);
v_int=round(v/du);
if (nargin<5)
    npt=max([max(u_int) max(v_int)]);
else
    npt=ceil(umax/du);
end


mat(2*npt+1,2*npt+1)=0;
u_int=u_int+npt+1;
v_int=v_int+npt+1;
for j=1:max(size(dat)),
    mat(u_int(j),v_int(j))=dat(j);
end
vec=du*(-npt:npt);
