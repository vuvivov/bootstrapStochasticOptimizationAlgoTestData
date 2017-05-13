function y = Holder(x)
y=0;
for i=1:length(x)
    for j=(i+1):length(x)
        y=y-abs(sin(x(i))*cos(x(j))*exp(abs(1-sqrt(x(i)^2+x(j)^2)/pi)));
    end
end