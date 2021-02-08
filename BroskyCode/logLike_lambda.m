function L=logLike_lambda(t,M,Param,Fixed);
%t2=[t]; % assume start at S=0 with t(1)=0;
%M2=[M];
lambda=CalcLambda(t,M,Param,Fixed);

a=sum(log(lambda(2:end)));
%dt=diff(t);
%mid_lambda=(lambda(2:end)+lambda(1:end-1))/2;
%b=sum(mid_lambda.*dt);
b=trapz(t,lambda);

L=a-b;

