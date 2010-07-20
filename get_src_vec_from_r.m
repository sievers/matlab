function[src_vec]=get_src_vec_from_r(amp,r,usrc,vsrc,u,v,pad)
nest=size(r,3);
src_vec(nest,1)=0;
for j=1:nest,
    if (abs(usrc-u(j))<=pad)&(abs(vsrc-v(j))<=pad)
        src_vec(j)=amp*r(usrc-u(j)+pad+1,vsrc-v(j)+pad+1,j);
    end
end

