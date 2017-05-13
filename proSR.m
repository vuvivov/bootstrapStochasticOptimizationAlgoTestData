function proSr=proSR(nf,nv,dataSize,nPro,sampleSize,sample,maxTime)
proSr=zeros(nf,length(nv),max(dataSize),2);
for i=1:nf
    for j=1:length(nv)
        cumT=0;
        incumF=inf;
        for k=1:dataSize(j)
            r=datasample(1:sampleSize,1);
            cumT=cumT+sample(1,i,j,r,2);
            if cumT>maxTime(i,j)
                cumT=proSr(i,j,k,2);
                incumF=inf;
                nPro(3,i,j)=nPro(3,i,j)+1;
            end
            incumF=min(incumF,sample(1,i,j,r,1));
            proSr(i,j,k,1)=incumF;
            proSr(i,j,k,2)=cumT;
        end
    end
end

