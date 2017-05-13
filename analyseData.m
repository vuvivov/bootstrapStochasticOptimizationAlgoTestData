initialization

% for i=1:nf
%     for j=1:length(nv)



qT=zeros(nT+1,length(p1));
qB=zeros(nT+1,length(p1),nSampleVary);
qB2=zeros(nT+1,length(p1),length(ciP1)+1);
tEff=p1;
figure;
for i=nf
    for j=length(nv)
%         i
%         j         

        load([dataFolder 'trueIncum_f' num2str(i) '_nv' num2str(nv(j))]);
        %t quantile
        for k=1:(nT+1)
            qT(k,:)=quantile(true(:,k),p1);
        end
        clearvars true;
        figure;
        for k=1:length(nPathB)
            for l=1:length(nSample)
                for ii=1:nSampleVary
                    k
                    l
                    ii
                    load([dataFolder 'bIncum_f' num2str(i) '_nv' num2str(nv(j)) '_nSp' num2str(nSample(l)) '_nSpV' num2str(ii)]);
                    %b quantile
                    for jj=1:(nT+1)
                        qB(jj,:,ii)=quantile(bootstrap(:,k),p1);
                    end
                end
                %b qCi
                for ii=1:(nT+1)
                    for jj=1:length(p1)
                        [tempP,tempQ]=ecdf(qB(ii,jj,:));
                        tempQ=qReduce(tempQ,tempP,p1);
                        for kk=1:length(ciP1)
                            qB2(ii,jj,kk)=tempQ(ciP1(kk));
                        end
                        qB2(ii,jj,kk+1)=mean(tempQ);
                    end
                end
                %effective t
                for ii=1:length(p1)
                    jj=1;
                    while qB2(jj,ii,1)<=qT(jj,ii)&&qB2(jj,ii,2)>=qT(jj,ii)
                        jj=jj+1;
                    end
                    tEff(ii)=(jj-2)/nT*tMax/tMean;
                end  
                %plot
                
                
                figure(1);
                subplot(length(nSample),length(nPathB),l+(k-1)*length(nSample));
                %effct T vs p
                figure(2);
                subplot(length(nSample),length(nPathB),l+(k-1)*length(nSample));
                %ci vs t
            end
        end
        figure(2);
        savefig('');close;
        clearvars bootstrap;
        
    end
end
figure(1);
savefig('');close;

        

    
    
    
    