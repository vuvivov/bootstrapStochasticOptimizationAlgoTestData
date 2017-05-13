%thread start from 1
function dataGenExecute(thread,nThread,nv)
nf=5;
%nv=[5 10 50];
nSeed=10^6;
bound=99;


workspaceName=['rawData_t' num2str(thread) '_nv' num2str(nv)];
if exist([workspaceName '.mat'])
    load(workspaceName);
else
    rawData=zeros(nf,nSeed,2);
    switch nv
        case 5
            jStart=47996;
        case 10
            jStart=3844;
        case 50
            jStart=723;
    end
end


rng('default');
% Bounds
lb0 =-ones(nv(length(nv)),1)*bound;
ub0 =-lb0;
% Starting Guess
x00 =random('unif',-bound, bound,nv(length(nv)),1);

for j=(jStart+1):nSeed
    for k=1:length(nv)
        lb=lb0(1:nv(k));
        ub=ub0(1:nv(k));
        x0=x00(1:nv(k));
            for i=1:nf
                j
                k
                i
                % Fitting Functions
                fun = @(x) obj(x,i,nv(k));
                seed=j*nThread+thread
                nopts = nomadset('seed',seed,'min_poll_size','1');
                %nopts.seed
               % nopts = nomadset('seed',double((j-1)*nThread+thread),'min_poll_size','1');
                %nopts = nomadset('min_poll_size','1','model_search_optimistic',p1,'opportunistic_eval',p2,'speculative_search',p3);
                % Options
                opts = optiset('solver','nomad','solverOpts',nopts);

                % Create OPTI Object
                Opt = opti('fun',fun,'bounds',lb,ub,'options',opts);

                % Attempt to Solve
                [x,fval,exitflag,info] = solve(Opt,x0);
                fval
                rawData(i,j,1)=fval;
                rawData(i,j,2)=info.Time;
                %rawData(i,k,j,1)=fval;
                %rawData(i,k,j,2)=info.Time;
            end
    end
    if mod(j,100)==0
        jStart=j;
        save(workspaceName);
    end
end

% temp=1:nSeed;
% temp2=temp;
% for j=1:nf
%     for i=1:length(temp)
%         temp(i)=data(j,1,i,1);
%         temp2(i)=data(j,1,i,2);
%     end
%     figure;scatter(temp2,temp);title(num2str(j))
% end
% 


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





