%generate quantile and tEffective; NF is the function index
function dataProcess2(indexI,indexJ)
initialization
qT=zeros(nT+1,length(p1));
qB=zeros(nT+1,length(p1),nSampleVary);
qB2=zeros(nT+1,length(p1),length(p1));
tEff=p1;
for i=indexI
    for j=indexJ
        i
        j         
        load([dataFolder 'trueIncum_f' num2str(i) '_nv' num2str(nv(j))]);
        %t quantile
        for k=1:(nT+1)
            qT(k,:)=quantile(true(:,k),p1);
        end
        clearvars true;
        save([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))],'qT','tMax','tMean');
        for k=1:length(nPathB)
            for l=1:length(nSample)
                for ii=1:nSampleVary
%                     k
%                     l
%                     ii
                    load([dataFolder 'bIncum_f' num2str(i) '_nv' num2str(nv(j)) '_nSp' num2str(nSample(l)) '_nSpV' num2str(ii)]);
                    %b quantile
                    for jj=1:(nT+1)
                        qB(jj,:,ii)=quantile(bootstrap(:,jj),p1);
                    end
                    clearvars bootstrap;
                end
                %b qCi
                for ii=1:(nT+1)
                    for jj=1:length(p1)
                        qB2(ii,jj,:)=quantile(qB(ii,jj,:),p1);
                    end
                end
                %effective t
                for ii=1:length(p1)
                    jj=1;
                    while qB2(jj,ii,ciP1(1))<=qT(jj,ii)&&qB2(jj,ii,ciP1(2))>=qT(jj,ii)
                        jj=jj+1;
                        if jj==(nT+2)
                            break;
                        end
                    end
                    tEff(ii)=(jj-2)/nT*tMax/tMean;
                end 
                save([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))],'qB2','tEff');
            end
        end 
    end
end
        

    
    
    
    