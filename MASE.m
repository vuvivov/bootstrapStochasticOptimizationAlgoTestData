%y is a vector of the actual values with size n;f is a n-m matrix contains
%m groups of forecast
function mase=MASE(f,y)
s=size(f);
mase=zeros(s(2),1);
for i=1:s(2)    
    mase(i)=(mean(abs(f(:,i)-y)))/(mean(abs(y(2:length(y))-y(1:(length(y)-1)))));
end
mase=mean(mase);
