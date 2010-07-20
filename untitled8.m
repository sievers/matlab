whos_mem_struct=whos;
whos_usage=0;
for whos_i=1:length(whos_mem_struct)
    whos_usage=whos_usage+prod(whos_mem_struct(whos_i).size);
end
disp(whos_usage/1024^2);
