%bootstrap and generate incumbent solution
function dataProcess(indexI,indexJ)
initialization
for i=indexI
    for j=indexJ
        i
        j        
        load('pop');
        %initial sample to generate parameter
        sample=pop(i,j,datasample(1:nPop,max(nSample)),:);
        f0=max(sample(1,1,:,1));
        tMax=sum(sample(1,1,:,2));
        tMean=mean(pop(i,j,:,2));
        nPerPath=ceil(tMax/min(pop(i,j,:,2)));
        %true simulation
        true=zeros(nPathTrue,nPerPath,2);
        for k=1:nPathTrue
            %k
            true(k,:,:)=pop(i,j,datasample(1:nPop,nPerPath),:);
        end
        %true incumbent
        true=incumbent(true,tMax,nT,f0);
        save([dataFolder 'trueIncum_f' num2str(i) '_nv' num2str(nv(j))],'true','tMax','tMean');
        clearvars true;
        %bootstrap
        for k=1:nSampleVary
            k
            sample=pop(i,j,datasample(1:nPop,max(nSample)),:);
            for kk=nSample
                %kk
                bootstrap=zeros(max(nPathB),nPerPath,2);
                for l=1:max(nPathB)
                    bootstrap(l,:,:)=sample(1,1,datasample(1:kk,nPerPath),:);
                end
                %b incumbent
                bootstrap=incumbent(bootstrap,tMax,nT,f0);
                save([dataFolder 'bIncum_f' num2str(i) '_nv' num2str(nv(j)) '_nSp' num2str(kk) '_nSpV' num2str(k)],'bootstrap');
            end
        end
        clearvars bootstrap;
    end
end
        
        
    
    
    
    