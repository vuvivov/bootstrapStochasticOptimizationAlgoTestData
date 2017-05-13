function sourceData=combineDataNew(sizePop)
NTHREAD=4;
NV=[5 10 50];
nf=5;
sourceData=zeros(nf,length(NV),sizePop,2);
JStart=[47996 3844 723];
jEnd=(JStart+1)*NTHREAD;
for I=1:nf
    I
        for J=1:length(NV)
            J
            temp=csvread(['f' num2str(I) 'nv' num2str(NV(J)) '.csv']);
            if size(temp)>sizePop
                temp=temp(1:sizePop,:);
            end
            sourceData(I,J,1:min(jEnd(J),size(temp)),:)=temp(1:min(jEnd(J),size(temp)),:);
            if jEnd(J)<sizePop
                for K=1:NTHREAD
                    K
                    load(['rawData_t' num2str(K) '_nv' num2str(NV(J))]);
                    for l=(JStart(J)+1):(sizePop/NTHREAD-1)
                        sourceData(I,J,l*NTHREAD+K,:)=rawData(I,l,:);
                        
                    end
                end
            end
        end
end
sourceData(2,:,:,1)=log(sourceData(2,:,:,1));
%sourceData=sourceData(:,:,1:sizePop,:);
sourceData=sourceData([2 3 4 5 1],:,1:sizePop,:);




% figure;
% title('t')
% for I=1:nf
%         for J=1:length(NV)
%             subplot(length(NV),nf,I+(J-1)*nf);
%             temp=1:sizePop;
%             temp2=temp;
%             for K=1:length(temp2)
%                 temp2(K)=sourceData(I,J,K,2);
%             end
%             plot(temp,temp2)
%         end
% end
% 
% figure;
% title('f')
% for I=1:nf
%         for J=1:length(NV)
%             subplot(length(NV),nf,I+(J-1)*nf);
%             temp=1:length(sourceData(I,J,:,2));
%             temp2=temp;
%             for K=1:length(temp2)
%                 temp2(K)=sourceData(I,J,K,1);
%             end
%             plot(temp,temp2)
%         end
% end