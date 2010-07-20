function[c,h]=plot_contours(varargin)
if (min(size(varargin{1}))==1)
    x=varargin{1};
    y=varargin{2};
    varargin=varargin(3:max(size(varargin)));
else
    x=1:size(varargin{1},2);
    y=1:size(varargin{1},1);
end
conts=varargin{max(size(varargin))};
varargin=varargin(1:max(size(varargin)-1));

nmat=max(size(varargin));
if (size(varargin{nmat})~=size(varargin{1}))
    cols=varargin{nmat};
    varargin=varargin(1:nmat-1);
    nmat=nmat-1;
else
    cols =[0 0 1
        1 0 0
        0 1 0
        0.5 0.5 0.5];
end

if (size(varargin{nmat})~=size(varargin{1}))
    cols_bot=varargin{nmat};
    varargin=varargin(1:nmat-1);
    nmat=nmat-1;
else
    cols_bot=0*cols;
end


big_mat(max(size(y)),max(size(x)),nmat)=0;
for j=1:nmat,
    big_mat(:,:,j)=varargin{j};
end
doflip=1;
if (doflip)
    big_mat=big_mat*-1;
    conts=conts*-1;
end

ncont_in=max(size(conts));
hold off
for j=1:nmat,
    [c_in,h(j)]=contour(x,y,big_mat(:,:,j),conts);
    hold on;
    c(1:size(c_in,1),1:size(c_in,2),j)=c_in;
    %set(h(j,k),'Color',cols(j,:)*(k/ncont));
end
hold off;
for j=1:nmat,
    [c_in,h(j)]=contour(x,y,big_mat(:,:,j),conts);
    [ncont,cont_level,starts]=how_many_conts(c_in);
    for k=1:ncont,
        which_cont=find(conts==cont_level(k));
        cur_cont=get_one_contour(c(:,:,j),k);
        %plot(cur_cont(1,:),cur_cont(2,:));
        cur_cont_clean=cur_cont(1,~isnan(cur_cont(1,:)));        
        cur_cont_clean(2,:)=cur_cont(2,~isnan(cur_cont(2,:)));
        %whos
        fill(cur_cont_clean(1,:),cur_cont_clean(2,:),cols(j,:)*((which_cont)/ncont_in)+cols_bot(j,:)*(ncont_in-which_cont)/ncont_in );
        hold on;
    end
end

for j=1:nmat,
    [c_in,h(j)]=contour(x,y,big_mat(:,:,j),conts);
    [ncont,cont_level,starts]=how_many_conts(c_in);
    for k=1:ncont,
        cur_cont=get_one_contour(c_in,k);
        cur_cont_clean=cur_cont(1,~isnan(cur_cont(1,:)));        
        cur_cont_clean(2,:)=cur_cont(2,~isnan(cur_cont(2,:)));

        hl=plot(cur_cont_clean(1,:),cur_cont_clean(2,:),'k--');
        %set(hl,'Color',0.5*cols(j,:)*(ncont+1-k)/ncont,'LineWidth',2);
        %set(hl,'LineWidth',2);
        %set(hl,'Color',cols(j,:)*(k/ncont));
    end
end


