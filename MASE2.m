%modified MASE. y is a vector of the actual values with size n;f is a n-m matrix contains
%m groups of forecast; I is the index of y that f compares with
function mase=MASE2(f,y,I)
s=size(f);
mase=zeros(s(2),1);
for i=1:s(2)    
    mase(i)=(mean(abs(f(:,i)-y(I))))/(mean(abs(y-mean(y))));
end
mase=mean(mase);
