% data=zeros(5,1,sum(size(:,3)),2);
% i=1;
% data(:,:,i:(i+size(1,3)-1),:)=data50(:,:,:,:);


% i=i+size(1,3);
% data(:,:,i:(i+size(2,3)-1),:)=data51(:,:,:,:);
% 
% i=i+size(2,3);
% data(:,:,i:(i+size(3,3)-1),:)=data52(:,:,:,:);
% 
% i=i+size(3,3);
% data(:,:,i:(i+size(4,3)-1),:)=data53(:,:,:,:);
nv=5;
k=191990;
    for j=1:nf
        output=zeros(k,2);
        for i=1:k
            output(i,1)=data(j,1,i,1);
            output(i,2)=data(j,1,i,2);
        end
        csvwrite(['f' num2str(j) 'nv' num2str(nv) '.csv'],output);
    end