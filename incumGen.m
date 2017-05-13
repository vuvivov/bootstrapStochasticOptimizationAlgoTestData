function [incum,incumSize,incumN,incumEnd]=incumGen(data,dataSize,maxTime)
SIZE=size(data);
incum=zeros(SIZE);
incumSize=zeros(SIZE(1:3));
incumN=incumSize;
incumEnd=zeros(SIZE(1:4) );
for l=1:SIZE(1)
    for i=1:SIZE(2)
        for j=1:SIZE(3)
            cumT=0;
            incumF=inf;
            for k=1:dataSize(j)
                cumT=cumT+data(l,i,j,k,2);
                if cumT>maxTime(i,j)
                    cumT=data(l,i,j,k,2);
                    incumF=inf;
                    incumN(l,i,j)=incumN(l,i,j)+1;
                    incumEnd(l,i,j,incumN(l,i,j))=incumSize(l,i,j);
                end
                if data(l,i,j,k,1)<incumF
                    incumF=data(l,i,j,k,1);
                    incumSize(l,i,j)=incumSize(l,i,j)+1;
                    incum(l,i,j,incumSize(l,i,j),1)=incumF;
                    incum(l,i,j,incumSize(l,i,j),2)=cumT;
                end
            end
        end
    end
end
incum=incum(:,:,:,1:max(max(max(incumSize))),:);
incumEnd=incumEnd(:,:,:,1:(max(max(max(incumN)))));
                    