for ii=5:99
    ii
    rng('default');
    resampleSize=10^ii;
    tcut=3;
    scale=1:10;
    %resample
    resample=zeros(resampleSize,nt);
    unscaledSampleT=zeros(sampleSize,1);
    figure;figure;
    greyScale=.75;
    ciF=zeros(nt,3);
    for i=1:nf
        for j=1:length(nv)
            t=(1:nt)/nt*sampleTCut(i,j,tcut);
            for k=1:length(unscaledSampleT)
                unscaledSampleT(k)=sample(1,i,j,k,2);
            end
            for l=1:length(scale)
                scaledSampleT=unscaledSampleT/scale(l);
                for k=1:resampleSize
                    temp3=initSol(3,i,j);
                    kk=1;
                    while kk<=length(t)
                        temp=datasample(1:length(scaledSampleT),1);
                        temp2=scaledSampleT(temp)+t(kk);
                        temp3=min(temp3,sample(1,i,j,temp,1));
                        while kk<=length(t)&& t(kk)<=temp2 
                            resample(k,kk)=temp3;
                            kk=kk+1;
                        end
                    end
                end
                %TODO: combine 3 quantile funcitons
                for k=1:nt
                        ciF(k,1)=median(resample(:,k));
                        ciF(k,2)=quantile(resample(:,k),pQuantile(1));
                        ciF(k,3)=quantile(resample(:,k),pQuantile(3));   
                end
                if l==1
                    figure(1);hold
                    subplot(3,5,(j-1)*5+i);hold
                    h(l)=plot(t,ciF(:,1),'Color',[1 1 1]*greyScale,'LineWidth',3);
                    fill([t,fliplr(t)],[ciF(:,2)',fliplr(ciF(:,3)')],1,'facecolor',[1 1 1]*greyScale,'edgecolor','none', 'facealpha', .3);
                    figure(2);hold
                    subplot(3,5,(j-1)*5+i);hold
                    h(l)=plot(t,ciF(:,1),'Color',[1 1 1]*greyScale,'LineWidth',3);
                    fill([t,fliplr(t)],[ciF(:,2)',fliplr(ciF(:,3)')],1,'facecolor',[1 1 1]*greyScale,'edgecolor','none', 'facealpha', .3);
                else
                    figure(1);hold
                    subplot(3,5,(j-1)*5+i);hold
                    plot(t,ciF(:,3));
                    figure(2);hold
                    subplot(3,5,(j-1)*5+i);hold
                    plot(t,ciF(:,1));
                end

            end


        end
    end
    figure(1);savefig('4_90%');   close
    figure(2);savefig('4_50%');     close
end
    %qq plot