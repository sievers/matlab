whos_mem_struct=whos;
whos_usage=0;
for whos_i=1:length(whos_mem_struct)
    whos_usage=whos_usage+whos_mem_struct(whos_i).bytes;
end
disp([num2str(whos_usage/1024^2) ' Mb']);
