function y = CrossInTray(x)
y=log(abs(prod(sin(x)).*exp(abs(100-sqrt(sum(x.^2))./pi))));