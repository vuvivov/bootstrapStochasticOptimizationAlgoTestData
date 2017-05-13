function y=obj(x,i,n)
x=x(1:n);
switch i
    case 1
        y=Ackley(x);
    case 2
        y=Levi(x);
    case 3
        y=CrossInTray(x);
    case 4
        y=eggholder(x);
    case 5
        y=Holder(x);
    otherwise
        y=0;
end