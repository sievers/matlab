function[inds]=find_many_string(arr1,arr2)
%For each string in arr1, find the index of the corresponding
%string in arr2, returning zero if it doesn't exist.  Pass in arr1
%and arr2 as cell arrays.

[arr1,ind1]=sort(arr1);
[arr2,ind2]=sort(arr2);
n1=length(ind1);
n2=length(ind2);

for j=2:n1,
  if strcmpc(arr1{j-1},arr1{j})>0
    error('had a screwup in sorting.');
  end
end
for j=2:n2,
  if strcmpc(arr2{j-1},arr2{j})>0
    error('had a screwup in sorting.');
  end
end
inds=zeros(n1,1);
k=1;
j=1;
while (j<=n1)&(k<=n2),

  val=strcmpc(arr1{j},arr2{k});
  %disp(num2str([j k val]))
  if (val==0)
    inds(j)=k;
    j=j+1;
  end
  if (val==-1)
    j=j+1;
  end
  if (val==1)
    k=k+1;
  end
end

if size(ind1,1)==1,
  ind1=ind1';
end
if size(ind2,1)==1,
  ind2=ind2';
end

ind1_back=0*ind1;for j=1:length(ind1),ind1_back(ind1(j))=j;end;
%ind2_back=0*ind2;for j=1:length(ind2),ind2_back(ind2(j))=j;end;
%ind1_back=sortrows([ind1 (1:length(ind1))'],1);ind1_back=ind1_back(:,2);
%ind2_back=sortrows([ind2 (1:length(ind2))'],1);ind2_back=ind2_back(:,2);

%inds(inds>0)=ind2_back(inds>0);
%inds=inds(ind1_back);


inds=inds(ind1_back);
inds(inds>0)=ind2(inds(inds>0));



