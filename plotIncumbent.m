function plotIncumbent(f,t,o)
F=f;T=t;
F(1)=f(o(1));
for i=2:length(o)
    F(i)=min(F(i-1),f(o(i)));
    T(i)=T(i-1)+t(i);
end
plot(T,F);