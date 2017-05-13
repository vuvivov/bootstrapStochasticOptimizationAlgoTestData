function [m,M]=tMaxMin(x,t,threshold)
x=(x<=threshold);
m=t(length(t));M=t(1);
temp=zeros(length(x),2);
j=1;
mySwitch=x(1);
if x(1)
    temp(1,1)=t(1);
end
for i=2:length(x)
    if mySwitch && (~x(i))
        temp(j,2)=t(i-1);
        j=j+1;
        mySwitch=0;
    elseif (~mySwitch) && x(i)
        temp(j,1)=t(i);
        mySwitch=1;
    elseif i==length(x)&&mySwitch==1
        temp(j,2)=t(i);
    end    
end
temp=temp(1:j,:);
len=temp(:,2)-temp(:,1)+1;
[A,B]=max(len);
if length(B)>0
    m=temp(B(1),1);M=temp(B(1),2);
end
