function ft=incumbent(data,tMax,nT,f0)
sizeData=size(data);
ft=zeros(sizeData(1),nT+1);
t=(0:nT)/nT*tMax;
ft(:,1)=f0;
for i=1:sizeData(1)
    incumF=f0;
    incumT=0;
    incumI=2;
    for j=1:sizeData(2)
        if incumI<=nT+1
            if incumT+data(i,j,2)<=tMax
                while t(incumI)-incumT<=data(i,j,2)
                    ft(i,incumI)=min(incumF,data(i,j,1));
                    incumI=incumI+1;
                end
                incumT=t(incumI-1);
                incumF=ft(i,incumI-1);
            else
                while incumI<=nT+1
                    ft(i,incumI)=ft(i,incumI-1);
                    incumI=incumI+1;
                end
                %break;
            end
        end
    end
    if incumI<=nT+1
        while incumI<=nT+1
            ft(i,incumI)=ft(i,incumI-1);
            incumI=incumI+1;
        end
    end
    
    
end