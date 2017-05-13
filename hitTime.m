%x(1,) needs to be decreasing function value
function t=hitTime(x,f)
t=zeros(length(x),1);
nt=0;
for i=1:(length(x)-1)
    if x(i,1)>f&&x(i+1,1)<=f
        nt=nt+1;
        t(nt)=x(i+1,2);
    end
end
t=t(1:nt);