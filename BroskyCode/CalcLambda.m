function lambda=CalcLambda(t,M,Param,Fixed);
C=Param(1);
%c=Param(2);
beta=Param(2);
mu=Param(3);

Mmin=Fixed(1);
c=Fixed(2);

N=length(t);
    
K=C.*10.^(M-Mmin);
Lambda=zeros(N,N); 
parfor i=1:length(t),    
 %   Num=K(i);
 %   Den=(c+t(i+1:N)-t(i)).^beta;
 %   Lambda_t(i,i+1:N)=Num./Den;
    Lambda(i,:)=K(i)./(c+t-t(i)).^beta;
    
end
% following two lines could be replaced by LU=triu(Lambda,1)
LU=triu(Lambda);
LU(1:N+1:N*N)=0;  
lambda=sum(LU,1)+mu;

%lambda=sum(Lambda_t,1);
%max(abs(lambda-lambda_test))
