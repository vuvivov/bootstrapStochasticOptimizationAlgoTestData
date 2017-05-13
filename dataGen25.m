nf=5;nSeed=10^5;nv=[25];
data=zeros(nf,length(nv),nSeed,2);
fun=cell(5,length(nv));
bound=99;

% Bounds
lb0 =-ones(nv(length(nv)),1)*bound;
ub0 =-lb0;

%plot verify
% res=1;
% value=res:res:bound;
% valueX=zeros(length(value)*length(value),1);
% valueY=valueX;
% f=zeros(nf,length(value)*length(value));
% for i=1:length(value)
%     for j=1:length(value)
%         valueX(i,j)=value();
%         for k=1:nf
%             i
%             j
%             f(k,(i-1)+j)=obj([valueX((i-1)+j) value((i-1)+j)],k,2);
%         end
%         
%     end
% end







% Starting Guess
x00 =random('unif',-bound, bound,nv(length(nv)),1);
minSize='.1';
for j=1:nSeed
    
    for k=1:length(nv)
        lb=lb0(1:nv(k));
        ub=ub0(1:nv(k));
        x0=x00(1:nv(k));
            for i=1:5
                j
                k
                i
                % Fitting Functions
                fun = @(x) obj(x,i,nv(k));
                
                
                %nopts = nomadset('seed',j);
                nopts = nomadset('min_poll_size','1');
                % Options
                opts = optiset('solver','nomad','solverOpts',nopts);

                % Create OPTI Object
                Opt = opti('fun',fun,'bounds',lb,ub,'options',opts);

                % Attempt to Solve
                [x,fval,exitflag,info] = solve(Opt,x0);
                data(i,k,j,1)=fval;
                data(i,k,j,2)=info.Time;
            end
    end
end

temp=1:nSeed;
temp2=temp;
for j=1:nf
    for i=1:length(temp)
        temp(i)=data(j,1,i,1);
        temp2(i)=data(j,1,i,2);
    end
    figure;scatter(temp2,temp);title(num2str(j))
end








