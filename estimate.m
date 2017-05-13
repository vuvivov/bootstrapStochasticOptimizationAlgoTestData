%estimate of the quantile at time t. t is the vector for time points to show; p is the vector for p-quantiles to
%show; data is the sample data; f is the estimate in a
%length(t)-by-length(p) matrix
function f = estimate(t,p,data)
f=zeros(length(t),length(p));
tMean=mean(data(:,2));
n=t./tMean;
[F,x]=ecdf(data(:,1));
for i=1:length(t)
    F_Temp=1-(1-F).^n(i);
    %TODO: optimize the follow nested loop
    for j=1:length(p)
        for k=2:length(F_Temp)
            %TODO: optimize interpolation between F_Temp values
            if p(j)>=F_Temp(k-1)&p(j)<=F_Temp(k)
                f(i,j)=(x(k-1)+x(k))/2;
            end
        end
    end
end