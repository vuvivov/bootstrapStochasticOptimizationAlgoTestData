
nv=[50];
dataSize=nv;
for l=1:length(nv)
    load(['data' num2str(nv(l))]);
    for i=1:10^5+s
        %data(1,nv,i,2)
        %pause(.1);

        if data(1,1,i,2)==0
            k=i;
            break;
        end

    end
    k=k-1
    dataSize(l)=k;

    for j=1:nf
        output=zeros(k,2);
        for i=1:k
            output(i,1)=data(j,1,i,1);
            output(i,2)=data(j,1,i,2);
        end
        csvwrite(['f' num2str(j) 'nv' num2str(nv(l)) '.csv'],output);
    end
end