%old version
initialization

% % %randomly choose scenario to show in fig1 %
% cases=zeros(nf*length(nv),2); % k=0; % for i=1:nf %     for
% j=1:length(nv) %         k=k+1; %         cases(k,1)=i; %
% cases(k,2)=j; %     end % end %
% caseShow=sort(datasample(1:length(cases),length(nPathB)*length(nSample),'Replace',false));
% 
%fig1
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
                %true
                handle=1;
                t=(0:nT)/nT*max(nSample);
                h(handle)=plot(t,qT(:,medianI),'Color',col(handle,:),'LineWidth',medianLineW);
                fill([t,fliplr(t)],[qT(:,ciP2(1))',fliplr(qT(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
                %estimate
                tempS=size(qB2);
                qBMean=zeros(tempS(1),tempS(2));
                for kk=1:tempS(1)
                    for ll=1:tempS(2)
                        qBMean(kk,ll)=mean(qB2(kk,ll,:));
                    end
                end
                handle=handle+1;
                h(handle)=plot(t,qBMean(:,medianI),'Color',col(handle,:),'LineWidth',medianLineW);
                fill([t,fliplr(t)],[qBMean(:,ciP2(1))',fliplr(qBMean(:,ciP2(2))')],1,'facecolor',col(handle,:),'edgecolor','none', 'facealpha', .3);  
                plot(t,(qB2(:,ciP2(1),floor(ciP1(1)))+qB2(:,ciP2(1),ceil(ciP1(1))))/2,'--','Color',col(handle,:));
                plot(t,(qB2(:,ciP2(1),floor(ciP1(2)))+qB2(:,ciP2(1),ceil(ciP1(2))))/2,'--','Color',col(handle,:));
                plot(t,(qB2(:,ciP2(2),floor(ciP1(1)))+qB2(:,ciP2(2),ceil(ciP1(1))))/2,':','Color',col(handle,:));
                plot(t,(qB2(:,ciP2(2),floor(ciP1(2)))+qB2(:,ciP2(2),ceil(ciP1(2))))/2,':','Color',col(handle,:));
                plot(t,(qB2(:,medianI,floor(ciP1(1)))+qB2(:,medianI,ceil(ciP1(1))))/2,'-.','Color',col(handle,:));
                plot(t,(qB2(:,medianI,floor(ciP1(2)))+qB2(:,medianI,ceil(ciP1(2))))/2,'-.','Color',col(handle,:));
%                 plot(t,qB2(:,medianI,ciP1(1)),'-.','Color',col(handle,:));
%                 plot(t,qB2(:,medianI,ciP1(2)),'-.','Color',col(handle,:));
                %fill([t,fliplr(t)],[qB2(:,ciP2(1),ciP1(1))',fliplr(qB2(:,ciP2(2),ciP1(1))')],1,'facecolor',[1 1 1]-1,'edgecolor','none', 'facealpha', .11);
                %fill([t,fliplr(t)],[qB2(:,ciP2(1),ciP1(2))',fliplr(qB2(:,ciP2(2),ciP1(2))')],1,'facecolor',[1 1 1]-1,'edgecolor','none', 'facealpha', .11);
                xlim([0,max(t)]);xlabel('\tau');ylabel('\Gamma(\tau), \Gamma(\tau;N,B)');
                %add legend to last subplot
            end
        end
        tightfig;
        saveas(figure(1),[figFolder 'figTF' '_f' num2str(i) '_n' num2str(nv(j))],'pdf');close;
    end
end

%fig2
figure;subF=0;
for l=1:length(nSample)
    for k=1:length(nPathB)
        subF=subF+1;
        subplot(length(nSample),length(nPathB),subF);hold;
        for i=1:nf
            for j=1:length(nv)
                load([dataFolder2 'plotT' '_f' num2str(i) '_nv' num2str(nv(j))]);load([dataFolder2 'plotB' '_f' num2str(i) '_nv' num2str(nv(j)) '_B' num2str(nPathB(k)) '_N' num2str(nSample(l))]);                
                %delete repeated tEff
                for ll=1:length(tEff)
                    if tEff(ll)==tEff(ll+1)
                        break;
                    end
                end
                tEffMax=tEff(ll);
                tEff=tEff(1:ll);
                for ll=1:length(tEff)
                    tEff(ll)=tEff(ll)/tEffMax*nSample(length(nSample));
                end
                %plot
                plot(tEff,p1(1:length(tEff)));
                ylim([0,.8]);
            end
        end
        title(['N=' num2str(nSample(l)) ' B=' num2str(nPathB(k))]);
        if l==length(nSample)
            xlabel('\tau');
        end
        if k==1
            ylabel('p');
        end
    end
end
% %legend
% legendStr='f=_ n=_ ';
% temp=legendStr;
% for i=1:(nf*length(nv)-1)
%     legendStr=[legendStr;temp];
% end
% k=1;
% for i=1:nf
%             for j=1:length(nv)
%                 legendStr(k,3)=num2str(i);
%                 legendStr(k,(length(temp)-1):length(temp))=num2str(nv(j),'%2d');
%                 if j==1
%                     legendStr(k,length(temp))=' ';
%                 end
%                 k=k+1;
%             end
% end
% legend(legendStr);
tightfig;
saveas(figure(1),[figFolder 'fig_p_tEff'],'pdf');close;

































