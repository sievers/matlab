function[val]=mystd(x)
if size(x,1)==1,
  mn=mean(x);
  val=sqrt(sum( (x-mn).^2)/(numel(x)-1));
  return
end

mn=mean(x);
val=0*mn;
nn=size(x,1);
for j=1:size(x,2),
  val(j)=sum( (x(:,j)-mn(j)).^2);
end
val=sqrt(val/(nn-1));