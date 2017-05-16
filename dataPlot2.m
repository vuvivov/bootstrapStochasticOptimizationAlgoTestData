%new version
initialization;
showT=1;
medianLineW=2;
t=(0:nT)/nT*max(nSample);
threshBias=[.1 .05];
MA=10;
nMA=round(MA/max(nSample)*nT);

pShow=[10 30 50 70 90]+1;
%illustrate with 4 samples,N=100 f1v5
fig=figure;
fig.Position=round([110 110 figMax(2)/1.5*figDef(1)/figDef(2) figMax(2)]/figOverSize);
qB=zeros(nT+1,length(p1));
plotOrder=[2 1 3 4];
for i=1:3
    for j=1:2
        subplot(3,2,(plotOrder(i)-1)*2+j);hold;
        if j==1
            title([num2str(plotOrder(i)) 'a']);%'f' num2str(i) 'n' num2str(nv(j))
        else
            title([num2str(plotOrder(i)) 'b']);
        end
        %'B' num2str(nPathB(k))
        load([dataFolder2 'plotT' '_f' num2str(1) '_nv' num2str(5)]);
        clearvars true; 
        %true
        handle=1;
        plot(t,qT(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
        h(handle)=fill([t,fliplr(t)],[qT(:,ciP2(1))',fliplr(qT(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
        %estimate
        load([dataFolder 'bIncum_f' num2str(1) '_nv' num2str(5) '_nSp' num2str(100) '_nSpV' num2str(i)]);
        
        if j==1
            temp=1:length(bootstrap)/2;
        else
            temp=(length(bootstrap)/2+1):length(bootstrap);
        end
        for jj=1:(nT+1)
            qB(jj,:)=quantile(bootstrap(temp,jj),p1);
        end
        handle=handle+1;
        plot(t,qB(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
        h(handle)=fill([t,fliplr(t)],[qB(:,ciP2(1))',fliplr(qB(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
        xlim([0 100]);
        if j==2%&&i==2
            legend(h,'Truth','Estimate');
        end
        xlabel('\tau');ylabel('G^{-1}_{\Gamma}(p;\tau)');
    end
end
tightfig;
saveas(figure(1),[figFolder '4sample'],'pdf');close;

%three separate pairs
fig=figure;
fig.Position=round([110 110 figMax(2)/1.5*figDef(1)/figDef(2) figMax(2)]/figOverSize);
qB=zeros(nT+1,length(p1));
plotOrder=[2 1 3 4];

plotOrder=[3 2 1 4];
 %plotOrder=[3 3 3 3];


for i=1:3
    for j=1:2
        subplot(3,2,(plotOrder(i)-1)*2+j);hold;
        if j==1
            title([num2str(plotOrder(i)+2) 'a']);%'f' num2str(i) 'n' num2str(nv(j))
        else
            title([num2str(plotOrder(i)+2) 'b']);
        end
        %'B' num2str(nPathB(k))
        load([dataFolder2 'plotT' '_f' num2str(1) '_nv' num2str(5)]);
        clearvars true; 
        %true
        handle=1;
        plot(t,qT(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
        h(handle)=fill([t,fliplr(t)],[qT(:,ciP2(1))',fliplr(qT(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
        %estimate
        load([dataFolder 'bIncum_f' num2str(1) '_nv' num2str(5) '_nSp' num2str(100) '_nSpV' num2str(i)]);
        
        if j==1
            temp=1:length(bootstrap)/2;
        else
            temp=(length(bootstrap)/2+1):length(bootstrap);
        end
        for jj=1:(nT+1)
            qB(jj,:)=quantile(bootstrap(temp,jj),p1);
        end
        handle=handle+1;
        plot(t,qB(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
        h(handle)=fill([t,fliplr(t)],[qB(:,ciP2(1))',fliplr(qB(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
        xlim([0 100]);
        if j==2%&&i==2
            legend(h,'Truth','Estimate');
        end
        xlabel('\tau');ylabel('G^{-1}_{\Gamma}(p;\tau)');
    end
end
tightfig;
saveas(figure(1),[figFolder '4sample'],'pdf');close;




%calculate
load([dataFolder2 'plotT' '_f' num2str(1) '_nv' num2str(nv(1))]);load([dataFolder2 'plotB' '_f' num2str(1) '_nv' num2str(nv(1)) '_B' num2str(nPathB(1)) '_N' num2str(nSample(1))]);
tempS=size(qB2);
qBMean=zeros(tempS(1),tempS(2));qBSd=qBMean;bias0=qBMean;bias=qBMean;biasMA=qBMean;
tauMaxMin=zeros(3,tempS(2),length(threshBias),2);
for i=1:nf
    for j=1:length(nv)
        for k=1:length(nPathB)
            for l=1:length(nSample)
                i
                j
                k
                l
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);load([dataFolder2 'plotBMeanSd' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);
                for kk=1:tempS(2)
                    for ll=1:tempS(1)
                        qBMean(ll,kk)=mean(qB2(ll,kk,pCdf(1):pCdf(2)));
                        qBSd(ll,kk)=std(qB2(ll,kk,pCdf(1):pCdf(2)));
                        bias0(ll,kk)=mean(abs(qBMean(ll,kk)-qT(ll,kk)))/(qT(1,1)-qT(ll,kk));%absolute bias
                        bias(ll,kk)=abs(mean(qB2(ll,kk,pCdf(1):pCdf(2))-qT(ll,kk)))/(qT(1,1)-qT(ll,kk));%average absolute error
                        if bias(ll,kk)==Inf
                            bias(ll,kk)=0;
                        end
                    end
                    for ll=(nMA):tempS(1)
                        biasMA(ll,kk)=mean(bias((ll-nMA+1):(ll),kk));
                    end
                    for ll=1:length(threshBias)
                        [tauMaxMin(1,kk,ll,1),tauMaxMin(1,kk,ll,2)]=tMaxMin(bias(:,kk),t,threshBias(ll));
                        [tauMaxMin(2,kk,ll,1),tauMaxMin(2,kk,ll,2)]=tMaxMin(biasMA((nMA):tempS(1),kk),t((nMA):tempS(1)),threshBias(ll));
                        [tauMaxMin(3,kk,ll,1),tauMaxMin(3,kk,ll,2)]=tMaxMin(abs(qBMean(:,kk)-qT(:,kk)),t,qBSd(:,kk));
                    end   
                end
                save([dataFolder2 'plotBMeanSd' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))],'qBMean','qBSd','bias0','bias','biasMA','tauMaxMin');
            end
        end
    end
end


%plot
%! fig5+ not right, need to put after the 2nd for
yMax=zeros(99,nf,length(nv));
for i=1:nf
    for j=1:length(nv)
        for k=1:length(nPathB)  
            i
            j
            k
            subF=zeros(99,1);
            %2by2
            fig1=figure;fig1.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
            fig2=figure;fig2.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
            fig3=figure;fig3.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
            fig4=figure;fig4.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
            %4by3
            fig5=figure;fig5.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            fig6=figure;fig6.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            fig7=figure;fig7.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            fig8=figure;fig8.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            fig9=figure;fig9.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            %2by2
            fig10=figure;fig10.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);

            for l=1:length(nSample)
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);load([dataFolder2 'plotBMeanSd' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);
 
                               %if k==length(nPathB)
                        %mean,+-sd
                        for ii=1:2
                            figure(ii);
                            subF(ii)=subF(ii)+1;
                            subplot(2,2,subF(ii));hold;
                            title(['N=' num2str(nSample(l))]);
                            %true
                            handle=1;
                            plot(t,qT(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
                            h(ii,handle)=fill([t,fliplr(t)],[qT(:,ciP2(1))',fliplr(qT(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  

                            %estimate
                            handle=handle+1;
                            plot(t,qBMean(:,ciP2(3)),'Color',col(handle,:),'LineWidth',medianLineW);
                            h(ii,handle)=fill([t,fliplr(t)],[qBMean(:,ciP2(1))',fliplr(qBMean(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);                 
                            xlim([0,max(t)]);xlabel('\tau');ylabel('G^{-1}_{\Gamma}(p;\tau)');
                            if subF(ii)==2
                                legend(h(ii,:),'Truth','Estimate');
                            end
                            if ii==2
                                plot(t,qBMean(:,ciP2(1))+qBSd(:,ciP2(1)),'--','Color',col(handle,:));
                                plot(t,qBMean(:,ciP2(1))-qBSd(:,ciP2(1)),'--','Color',col(handle,:));
                                plot(t,qBMean(:,ciP2(2))+qBSd(:,ciP2(2)),':','Color',col(handle,:));
                                plot(t,qBMean(:,ciP2(2))-qBSd(:,ciP2(2)),':','Color',col(handle,:));
                            end  
                        end
                        %bias
                        figure(3);
                        subF(3)=subF(3)+1;
                        subplot(2,2,subF(3));hold;
                        title(['N=' num2str(nSample(l))]); 
                        for ii=pShow 
                            plot(t,bias(:,ii));                    
                        end
                        yMax(1,i,j)=max(yMax(1,i,j),max(max(bias(:,pShow))));
                        xlim([0,max(t)]);xlabel('\tau');ylabel('Relative Error');
                        if subF(3)==4
                            legend('10%','30%','50%','70%','90%','Location','best');
                        end
                        %biasMA
                        figure(4);
                        subF(4)=subF(4)+1;
                        subplot(2,2,subF(4));hold;
                        title(['N=' num2str(nSample(l))]); 
                        for ii=pShow
                            plot(t(nMA:length(t)),biasMA(nMA:length(t),ii));
                        end
                        yMax(2,i,j)=max(yMax(2,i,j),max(max(biasMA(:,pShow))));
                        xlim([0,max(t)]);xlabel('\tau');ylabel('Bias MA');
                        if subF(4)==4
                            legend('10%','30%','50%','70%','90%','Location','best');
                        end 
                        %biasDiff
                        figure(10);
                        subF(10)=subF(10)+1;
                        subplot(2,2,subF(10));hold;
                        title(['N=' num2str(nSample(l))]); 
                        biasDiff=bias-bias0;
                        for ii=pShow
                            plot(t,biasDiff(:,ii)); 
                        end
                        yMax(10,i,j)=max(yMax(10,i,j),max(max(biasDiff(:,pShow))));
                        xlim([0,max(t)]);xlabel('\tau');ylabel('Error-Bias');
                        if subF(10)==4
                            legend('10%','30%','50%','70%','90%','Location','best');
                        end 
                    end
                    %tauMinMax
                    iFig=4;
                    for ii=1:length(threshBias)
                        for jj=1:3
                            iFig=iFig+1;
                            if iFig<10
                                figure(iFig);
                                subF(iFig)=subF(iFig)+1;
                                subplot(4,3,subF(iFig));hold;
                                title(['N=' num2str(nSample(l)) ' B=' num2str(nPathB(k))]); 
                                plot(squeeze(tauMaxMin(jj,:,ii,1)),p1,'color','r');
                                plot(squeeze(tauMaxMin(jj,:,ii,2)),p1,'color','b');
                                if subF(iFig)==3
                                    legend('\tau_{min}','\tau_{max}','Location','best');
                                end
                            end
                        end
                    end

                end

            figure(1);
            tightfig;
            saveas(figure(1),[figFolder 'figMean' '_f' num2str(i) '_n' num2str(nv(j)) '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(2);
            tightfig;
            saveas(figure(2),[figFolder 'figMeanSd' '_f' num2str(i) '_n' num2str(nv(j)) '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(3);
            subF(3)=0;
            for l=1:length(nSample)              
                subF(3)=subF(3)+1;
                subplot(2,2,subF(3));hold;
                ylim([0,yMax(1,i,j)]);
            end
            tightfig;
            saveas(figure(3),[figFolder 'figError' '_f' num2str(i) '_n' num2str(nv(j)) '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(4);
            subF(4)=0;
            for l=1:length(nSample)              
                subF(4)=subF(4)+1;
                subplot(2,2,subF(4));hold;
                ylim([0,yMax(2,i,j)]);
            end
            tightfig;
            saveas(figure(4),[figFolder 'figErrorMA' num2str(MA) '_f' num2str(i) '_n' num2str(nv(j)) '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(5);
            tightfig;
            saveas(figure(5),[figFolder 'figReliable10%' '_f' num2str(i) '_n' num2str(nv(j)) '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(6);
            tightfig;
            saveas(figure(6),[figFolder 'figReliableMA10%' '_f' num2str(i) '_n' num2str(nv(j)) '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(7);
            tightfig;
            saveas(figure(7),[figFolder 'figReliableSd' '_f' num2str(i) '_n' num2str(nv(j)) '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(8);
            tightfig;
            saveas(figure(8),[figFolder 'figReliable5%' '_f' num2str(i) '_n' num2str(nv(j)) '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(9);
            tightfig;
            saveas(figure(9),[figFolder 'figReliableMA5%' '_f' num2str(i) '_n' num2str(nv(j)) '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
            figure(10);
            subF(10)=0;
            for l=1:length(nSample)              
                subF(10)=subF(10)+1;
                subplot(2,2,subF(10));hold;
                ylim([0,yMax(10,i,j)]);
            end
            tightfig;
            saveas(figure(10),[figFolder 'figErrorDiff' '_f' num2str(i) '_n' num2str(nv(j)) '_B' num2str(nPathB(k))],'pdf');close;pause(1);
        end
end

%max, mean and difference of bias
for k=1:length(nPathB)
    for l=1:length(nSample)
        fig1=figure;fig1.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
        fig2=figure;fig2.Position=round([110 110 figMax(1) figMax(1)/(figDef(1)/figDef(2))]/figOverSize);
        subF=zeros(99,1);yMax=zeros(3,nf,length(nv));
        for i=1:nf
            for j=1:length(nv)
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);load([dataFolder2 'plotBMeanSd' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);
                if i==1&&j==1
                    biasMax=bias;
                    biasMean=bias;
                else
                    biasMax=max(biasMax,bias);
                    biasMean=biasMean+bias;
                end
            end
        end
        biasMean=biasMean/(nf*length(nv));
        %plot
        %subF(3)=subF(3)+1;
        figure(1);
        %subplot(2,2,l);
        hold;
        %title(['N=' num2str(nSample(l))]); 
        for ii=pShow 
            plot(t,biasMean(:,ii));                    
        end
        yMax(1,i,j)=max(yMax(1,i,j),max(max(biasMean(:,pShow))));
        xlim([0,max(t)]);xlabel('\tau');ylabel('Relative Error');
        %if subF(3)==4
            %legend('10%','30%','50%','70%','90%','Location','best');
        %end
        legend('10%','30%','50%','70%','90%','Location','northwest');
        figure(2);
        %subplot(2,2,l);
        hold;
        %title(['N=' num2str(nSample(l))]); 
        for ii=pShow 
            plot(t,biasMax(:,ii));                    
        end
        yMax(2,i,j)=max(yMax(2,i,j),max(max(biasMax(:,pShow))));
        xlim([0,max(t)]);xlabel('\tau');ylabel('Relative Error');
        %if subF(3)==4
            %legend('10%','30%','50%','70%','90%','Location','best');
        %end
        legend('10%','30%','50%','70%','90%','Location','northwest');

        figure(1);
        subF(3)=0;
        % for l=1:length(nSample)              
        %     subF(3)=subF(3)+1;
        %     subplot(2,2,subF(3));hold;
            ylim([0,yMax(1,i,j)]);
        % end
        tightfig;
        saveas(figure(1),[figFolder 'figErrorMean' '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
        figure(2);
        subF(3)=0;
        % for l=1:length(nSample)              
        %     subF(3)=subF(3)+1;
        %     subplot(2,2,subF(3));hold;
            ylim([0,min(.5,yMax(2,i,j))]);
        % end
        tightfig;
        saveas(figure(2),[figFolder 'figErrorMax' '_N' num2str(nSample(l))  '_B' num2str(nPathB(k))],'pdf');close;pause(1);
    end
end



                
              
            
    


%tauMinMax consolidate
type=cell(3);
type{1}='bias';type{2}='ErrorMA';type{3}='Sd';
iFig=0;
col=rand(nf,length(nv),3);
for ii=1:length(threshBias)
    for jj=1:3
        subF=0;
        iFig=iFig+1;
        if iFig<6
            %4by3
            fig1=figure;fig1.Position=round([110 110 figMax(1) figMax(1)]/figOverSize);
            for l=1:length(nSample)
                for k=1:length(nPathB)
                    subF=subF+1;
                    subplot(length(nSample),length(nPathB),subF);hold;
                    for i=1:nf
                        for j=1:length(nv)
                            load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);   load([dataFolder2 'plotBMeanSd' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);             
                            title(['N=' num2str(nSample(l)) ' B=' num2str(nPathB(k))]); 
                            plot(squeeze(tauMaxMin(jj,:,ii,1)),p1,':','color',squeeze(col(i,j,:)));
                            plot(squeeze(tauMaxMin(jj,:,ii,2)),p1,'color',squeeze(col(i,j,:)));
                            if i==1&&j==1&&l==1&&k==1&&subF==3
                                lengend('\tau_{min}','\tau_{max}','Location','best');
                            end
                            if l==length(nSample)
                                xlabel('\tau');
                            end
                            if k==1
                                ylabel('p');
                            end
                        end
                    end
                end
            end
            tightfig;
            saveas(figure(1),[figFolder 'figTPAll'  type{jj} num2str(threshBias(ii)) '.pdf'],'pdf');close;pause(1);
        end
    end
end


%ARCHIVED
%vary N&B show modified MASE of 10%~90%, f1v5
pShow=10:10:90;
bias=zeros(length(t),1);
sdEst=bias;
for i=1:nf
    for j=1:length(nv)
        i
        j
        subF=0;
        figure;
        for k=length(nPathB)
            for l=1:length(nSample)              
                subF=subF+1;
                subplot(2,2,subF);hold;
                %i=cases(caseShow(subF),1);j=cases(caseShow(subF),2);
                title(['N=' num2str(nSample(l))]);%'f' num2str(i) 'n' num2str(nv(j))  'B' num2str(nPathB(k))
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);
                clearvars true; 
                for ii=pShow
                    for jj=1:length(t)
                        bias(jj)=abs(mean(qB2(jj,ii+1,:))-qT(jj,ii+1))./std(qT(jj,:));
                    end
                    plot(t,bias);
                end
                xlim([0,max(t)]);xlabel('\tau');ylabel('Relative Error');
                if subF==2
                    legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','Location','best');
                end
            end
        end
        tightfig;
        saveas(figure(1),[figFolder 'figBias' '_f' num2str(i) '_n' num2str(nv(j))],'pdf');close;
    end
end
for i=1:nf
    for j=1:length(nv)
        i
        j
        subF=0;
        figure;
        for k=length(nPathB)
            for l=1:length(nSample)              
                subF=subF+1;
                subplot(2,2,subF);hold;
                %i=cases(caseShow(subF),1);j=cases(caseShow(subF),2);
                title(['N=' num2str(nSample(l))]);%'f' num2str(i) 'n' num2str(nv(j))  'B' num2str(nPathB(k))
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);
                clearvars true; 
                for ii=pShow
                    for jj=1:length(t)
                        sdEst(jj)=std(qB2(jj,ii+1,:))./std(qT(jj,:));
                    end
                    plot(t,sdEst);
                end
                xlim([0,max(t)]);xlabel('\tau');ylabel('Standard Error');
                if subF==2
                    legend('10%','20%','30%','40%','50%','60%','70%','80%','90%','Location','best');
                end
            end
        end
        tightfig;
        saveas(figure(1),[figFolder 'figSe' '_f' num2str(i) '_n' num2str(nv(j))],'pdf');close;
    end
end