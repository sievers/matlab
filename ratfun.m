function[value]=ratfun(x,top,bottom)
top_poly=polyval(top,x);
bot_poly=1+x.*polyval(bottom,x);
%hold off;plot(x,top_poly);hold on;plot(x,bot_poly,'r');hold off;
value=top_poly./bot_poly;