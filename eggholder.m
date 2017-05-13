function y = eggholder(x)
y=0;
for i=1:length(x)
    for j=(i+1):length(x)
        y=y+(x(j)+47)*sin(sqrt(abs(x(i)/2+x(j)+47)))+x(i)*sin(sqrt(abs(x(i)-x(j)-47)));
    end
end
y=log(abs(y));