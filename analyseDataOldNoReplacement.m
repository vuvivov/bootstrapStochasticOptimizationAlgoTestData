rng('default');
nv=[5 10 50];
sizePop=70000;
pop=combineDataNew(sizePop);
dataSize=sizePop.*ones(1,3);
nf=5;
col=[1 0 0 ;0 0 1; 1 1 0;0 1 1;0 1 0;];

%generate pseudo data
for sampleSize=[100]
    %pop=zeros(nf,length(nv),max(dataSize),2);
    sample=zeros(2,nf,length(nv),sampleSize,2);
    data=zeros(4,nf,length(nv),max(dataSize),2);
    %generate seed
    seed=zeros(length(dataSize),max(dataSize),2);
    %first create with replacement, then merge to without replacement; find
    %missing seeds rearrange fill without replacement
    for j=1:length(dataSize)
        seedTable=zeros(dataSize(j),1);
        nSeedNR=0;
        temp=datasample(1:dataSize(j),dataSize(j));
        for i=1:length(temp)
            seed(j,i,1)=temp(i);%with replacement
            if seedTable(temp(i))==0
                seedTable(temp(i))=1;
                nSeedNR=nSeedNR+1;
                seed(j,nSeedNR,2)=temp(i);
            end
        end
        restSeed=zeros(dataSize(j)-nSeedNR,1);
        nRestSeed=0;
        for i=1:length(seedTable)
            if seedTable(i)==0
                nRestSeed=nRestSeed+1;
                restSeed(nRestSeed)=i;
            end
        end
        restSeed=datasample(restSeed,length(restSeed));
        for i=(nSeedNR+1):dataSize(j)
            seed(j,i,2)=restSeed(i-nSeedNR);
        end
    end
    %generate data
    for i=1:nf
        for j=1:length(nv)
%             temp=csvread(['f' num2str(i) 'nv' num2str(nv(j)) '.csv']);
%             for k=1:dataSize(j)
%                 pop(i,j,k,1)=temp(k,1);
%                 pop(i,j,k,2)=temp(k,2);
%             end

            temp=zeros(dataSize(j),2);
            for kk=1:length(temp)
                temp(kk,1)=seed(j,kk,1);
                temp(kk,2)=seed(j,kk,2);
            end


            for k=1:dataSize(j)
                data(1,i,j,k,1)=pop(i,j,temp(k,1),1);
                data(1,i,j,k,2)=pop(i,j,temp(k,1),2);
            end

            for k=1:dataSize(j)
                data(2,i,j,k,1)=pop(i,j,temp(k,2),1);
                data(2,i,j,k,2)=pop(i,j,temp(k,2),2);
            end

            for k=1:sampleSize
                sample(1,i,j,k,1)=data(1,i,j,temp(k,1),1);
                sample(1,i,j,k,2)=data(1,i,j,temp(k,1),2);
            end

            for k=1:sampleSize
                sample(2,i,j,k,1)=data(2,i,j,temp(k,2),1);
                sample(2,i,j,k,2)=data(2,i,j,temp(k,2),2);
            end

        end
    end


    figure
    for i=1:length(nv)
        for j=1:nf
            subplot(3,5,(i-1)*5+j)
            hold
            scatter(data(2,j,i,1:dataSize(i),2),data(2,j,i,1:dataSize(i),1),'MarkerEdgeColor',col(2,:))
            scatter(data(1,j,i,1:dataSize(i),2),data(1,j,i,1:dataSize(i),1),'MarkerEdgeColor',col(1,:))
            scatter(sample(2,j,i,:,2),sample(2,j,i,:,1),'MarkerEdgeColor',col(4,:))
            scatter(sample(1,j,i,:,2),sample(1,j,i,:,1),'MarkerEdgeColor',col(3,:))
            title(['f' num2str(j) 'nv' num2str(nv(i))])
            legend('obnr','obr','snr','sr')
        end
    end
    savefig('1');close
    clearvars pop restSeed seed seedTable;
    %resample
    for i=1:nf
        for j=1:length(nv)
            temp=datasample(1:sampleSize,dataSize(j));
            for k=1:dataSize(j)
                data(3,i,j,k,1)=sample(1,i,j,temp(k),1);
                data(3,i,j,k,2)=sample(1,i,j,temp(k),2);
            end
            seq=1:100:dataSize(j);
            for k=1:(length(seq))

                if k<length(seq)
                    temp=datasample(1:sampleSize,sampleSize,'Replace',false);
                    for l=1:sampleSize
                        data(4,i,j,l+seq(k)-1,1)=sample(2,i,j,temp(l),1);
                        data(4,i,j,l+seq(k)-1,2)=sample(2,i,j,temp(l),2);
                    end
                else
                   temp=datasample(1:sampleSize,dataSize(j)-seq(k)+1,'Replace',false);
                    for l=1:(dataSize(j)-seq(k)+1)
                        data(4,i,j,l+seq(k)-1,1)=sample(2,i,j,temp(l),1);
                        data(4,i,j,l+seq(k)-1,2)=sample(2,i,j,temp(l),2);
                    end
                end
            end
        end
    end
    %initial solution
    initSol=zeros(4,nf,length(nv));
    for l=1:4
        for i=1:nf
            for j=1:length(nv)
                initSol(l,i,j)=max(data(l,i,j,:,1));
            end
        end
    end

    %generate incumbent solution and time
    maxTime=zeros(nf,length(nv));
    for i=1:nf
        for j=1:length(nv)
            maxTime(i,j)=sum(sample(2,i,j,:,2));
        end
    end
    [incum,incumSize,incumN,incumEnd]=incumGen(data,dataSize,maxTime);

    figure
    for i=1:length(nv)
        for j=1:nf
            subplot(3,5,(i-1)*5+j)
            hold
            for k=[2 1 4 3]
                scatter(incum(k,j,i,1:incumSize(2,j,i),2),incum(k,j,i,1:incumSize(2,j,i),1),'MarkerEdgeColor',col(k,:))
            end
            title(['f' num2str(j) 'nv' num2str(nv(i))])
            legend('obnr','obr','snr','sr')
        end
    end
    savefig('2')    ;close

    % %NEED TO REVISE: distribution of hitting time
    % epsilon=[1:9 10:10:90]/100;
    % hitTimeObS=zeros(length(epsilon),4,nf,length(nv),max(dataSize));
    % nHT=zeros(length(epsilon),4,nf,length(nv));
    % for e=1:length(epsilon)
    %     figure;
    %     for i=1:nf
    %         for j=1:length(nv)      
    %             tempIn=zeros(dataSizeSnr(j),2);
    %             for k=1:length(tempIn)
    %                 tempIn(k,1)=proSnr(i,j,k,1);
    %                 tempIn(k,2)=proSnr(i,j,k,2);
    %             end
    %             %f range
    %             tempRange=zeros(sampleSize,1);
    %             for k=1:length(tempRange)
    %                 tempRange(k)=sample(2,i,j,k,1);
    %             end
    %             tempRange2=zeros(sampleSize,1);
    %             for k=1:length(tempRange)
    %                 tempRange2(k)=sample(1,i,j,k,1);
    %             end
    %             tempRangeMin=max(min(tempRange),min(tempRange2));
    %             tempRange=zeros(sampleSize,1);
    %             for k=1:length(tempRange)
    %                 tempRange(k)=proObS(1,i,j,k,1);
    %             end
    %             tempRange2=zeros(sampleSize,1);
    %             for k=1:length(tempRange)
    %                 tempRange2(k)=proObS(2,i,j,k,1);
    %             end
    %             tempRangeRange=max(max(tempRange),max(tempRange2))-tempRangeMin;
    %             temp=hitTime(tempIn,tempRangeMin+epsilon(e)*tempRangeRange);
    %             nHT(e,1,i,j)=length(temp);
    %             hitTimeObS(e,1,i,j,1:length(temp))=temp; 
    %             
    %             tempIn=zeros(dataSize(j),2);
    %             for k=1:length(tempIn)
    %                 tempIn(k,1)=proObS(2,i,j,k,1);
    %                 tempIn(k,2)=proObS(2,i,j,k,2);
    %             end
    %             temp=hitTime(tempIn,tempRangeMin+epsilon(e)*tempRangeRange);
    %             nHT(e,2,i,j)=length(temp);
    %             hitTimeObS(e,2,i,j,1:length(temp))=temp; 
    %             
    %             tempIn=zeros(dataSize(j),2);
    %             for k=1:length(tempIn)
    %                 tempIn(k,1)=proSr(i,j,k,1);
    %                 tempIn(k,2)=proSr(i,j,k,2);
    %             end
    %             temp=hitTime(tempIn,tempRangeMin+epsilon(e)*tempRangeRange);
    %             nHT(e,3,i,j)=length(temp);
    %             hitTimeObS(e,3,i,j,1:length(temp))=temp;  
    % 
    %             tempIn=zeros(dataSize(j),2);
    %             for k=1:length(tempIn)
    %                 tempIn(k,1)=proObS(1,i,j,k,1);
    %                 tempIn(k,2)=proObS(1,i,j,k,2);
    %             end          
    % 
    %             temp=hitTime(tempIn,tempRangeMin+epsilon(e)*tempRangeRange);
    %             nHT(e,4,i,j)=length(temp);
    %             hitTimeObS(e,4,i,j,1:length(temp))=temp;
    %             
    %             subplot(3,5,(j-1)*5+i)
    %             hold
    %             for k=[2 4 1 3]
    %                 temp=zeros(nHT(e,k,i,j),1);
    %                 for kk=1:length(temp)
    %                     temp(kk)=hitTimeObS(e,k,i,j,kk);
    %                 end
    %                 
    %                 if ~isempty(temp)
    %                      ecdf(temp);
    %                 end
    %             end
    %             legend('obnr','obr','snr','sr');
    %             h=findobj(gca);
    %             set(h(5),'Color',[0 0 1]);
    %             set(h(4),'Color',[1 0 0]);
    %             set(h(3),'Color',[0 1 1]);
    %             set(h(2),'Color',[1 1 0]);
    %         end
    %     end
    %     savefig(['cdf_e' num2str(epsilon(e)) '.fig']);close
    %     
    % end
    % 
    %distribution of function value
    nt=100;pQuantile=[.1 .5 .9];
    sampleTQP=10:10:90;
    sampleTCut=zeros(nf,length(nv),length(sampleTQP));
    figure
    for i=1:nf
        for j=1:length(nv)
            subplot(3,5,(j-1)*5+i);hold
            %omit without replacement
            for l=[2 4]
                t=(1:nt)/nt*maxTime(i,j);
                distF=zeros(length(t),incumN(l,i,j));
                kk=1;kkk=1;
                incumF=initSol(l,i,j);
                cumT=0;
                for k=1:incumEnd(l,i,j,incumN(l,i,j))
                    cumT=incum(l,i,j,k,2);
                    while kkk<=nt&&t(kkk)<=cumT
                        distF(kkk,kk)=incumF;
                        kkk=kkk+1;
                    end
                    incumF=incum(l,i,j,k,1);

                    if incumEnd(l,i,j,kk)==k
                        for kkkk=kkk:nt
                            distF(kkkk,kk)=incumF;
                        end
                        kk=kk+1;
                        kkk=1;
                        cumT=0;
                        incumF=initSol(l,i,j);
                    end
                end

                ciF=zeros(nt,3);
                for k=1:nt
                    ciF(k,1)=median(distF(k,:));
                    ciF(k,2)=quantile(distF(k,:),pQuantile(1));
                    ciF(k,3)=quantile(distF(k,:),pQuantile(3));
                end


                h(l/2)=plot(t,ciF(:,1),'Color',col(l,:)); 
                fill([t,fliplr(t)],[ciF(:,2)',fliplr(ciF(:,3)')],1,'facecolor',col(l,:),'edgecolor','none', 'facealpha', .3);  


            end
    %         %without bootstrap
    %         tempSample=zeros(sampleSize,2);
    %         for l=1:sampleSize
    %             tempSample(l,1)=sample(1,i,j,l,1);
    %             tempSample(l,2)=sample(1,i,j,l,2);
    %         end
    %         est=estimate(t,pQuantile,tempSample);
    %         h(3)=plot(t,est(:,2),'Color',col(5,:)); 
    %         fill([t,fliplr(t)],[est(:,1)',fliplr(est(:,3)')],1,'facecolor',col(5,:),'edgecolor','none', 'facealpha', .3);




%             %only use x% sample
%             sampleT=zeros(sampleSize,1);
%             for k=1:length(sampleT)
%                 sampleT(k)=sample(2,i,j,k,2);
%             end
%             sampleT=sort(sampleT);
% 
%             for k=1:length(sampleTQP)
%                 sampleTCut(i,j,k)=sum(sampleT(1:sampleTQP(k)));
%                 plot([1 1]*sampleTCut(i,j,k),ylim,'Color',[1 1 1]*.5);
%                 text(sum(sampleT(1:sampleTQP(k))),mean(ylim),[num2str(sampleTQP(k)) '%'],'Color',[1 1 1]*.5);
%             end

            title(['f' num2str(i) 'nv' num2str(nv(j))])
            %legend(h,'obnr','obr','snr','sr','est');
            %legend(h,'obr','sr','est');
        end
    end
    savefig('3')    ;close
end
% %transparent            
% open('3.fig')
% for i=1:3
%    for j=1:5
%         subplot(3,5,(i-1)*5+j)
%         set(gcf, 'color', 'none');
%  set(gca, 'color', 'none');
%    end
% end
% savefig('3transparent.fig');   close

                
        
    
    
    
    