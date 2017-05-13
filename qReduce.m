%use interpolation to reduce nQuantile 
function q1= qReduce(q0,p0,p1)
q1=p1;
q1(1)=q0(1);q1(length(q1))=q0(length(q0));
j=1;
for i=2:(length(p1)-1)
    while p0(j)<p1(i)
        j=j+1;
    end
    q1(i)=interp1([p0(j-1) p0(j)],[q0(j-1) q0(j)],p1(i));
end