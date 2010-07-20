function[value]=predict_ee(params,x,poly_sizes)
f_ntop=poly_sizes(1);
f_nbot=poly_sizes(2);
g_ntop=poly_sizes(3);
g_nbot=poly_sizes(4);


k=params(1);
phi=params(2);
params_used=2;

f_top=params(params_used+1:params_used+f_ntop);
params_used=params_used+f_ntop;
f_bot=params(params_used+1:params_used+f_nbot);
params_used=params_used+f_nbot;

g_top=params(params_used+1:params_used+g_ntop);
params_used=params_used+g_ntop;
g_bot=params(params_used+1:params_used+g_nbot);
params_used=params_used+g_nbot;

f=ratfun(x,f_top,f_bot);
g=ratfun(x,g_top,g_bot);
value=f + g.*sin(x*k+phi);

%figure(2);
%hold off;
%plot(x,f);
%hold on;
%plot(x,g.*sin(x*k+phi),'r');
%hold off;
