function y = Levi(x)
y=0;
for i=1:length(x)
    for j=(i+1):length(x)
        y=y+sin(3.*pi.*x(i))^2+(x(i)-1)^2*(1+sin(3*pi*x(j))^2)+(x(j)-1)^2*(1+sin(2*pi*x(j))^2);
    end
end
