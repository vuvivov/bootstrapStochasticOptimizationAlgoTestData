function [proSnr,dataSizeSnr]=proSNR(nf,nv,dataSize,nPro,sampleSize,sample,maxTime)
proSnr=zeros(nf,length(nv),max(dataSize),2);
dataSizeSnr=dataSize;
for i=1:nf
    for j=1:length(nv)
        sqSnr=1:100:dataSize(j);
        dataSizeSnr(j)=sqSnr(length(sqSnr))-1;
        for k=sqSnr(1:(length(sqSnr)-1))
            temp=datasample(1:sampleSize,sampleSize,'Replace',false);
            for l=1:sampleSize
                proSnr(i,j,l+k-1,1)=sample(2,i,j,temp(l),1);
                proSnr(i,j,l+k-1,2)=sample(2,i,j,temp(l),2);
            end
        end
    end
end

for i=1:nf
    for j=1:length(nv)
            cumT=0;
            incumF=inf;
            for k=1:dataSizeSnr(j)
                cumT=cumT+proSnr(i,j,k,2);              
                if cumT>maxTime(i,j)
                    cumT=proSnr(i,j,k,2);
                    incumF=inf;
                    nPro(4,i,j)=nPro(4,i,j)+1;
                end
                incumF=min(incumF,proSnr(i,j,k,1));
                proSnr(i,j,k,1)=incumF;
                proSnr(i,j,k,2)=cumT;
            end
    end
end
