function [EE,E]=errorMLE_num(t,M,Param,Fixed);
 % Ogata's error matrix eq. 7 1983
 % ouputs 1 sigma error in diagonal elements (EE) and full co-variance matrix E
 % input t,M, fit Params and fixed params (Mmin, b)

 dt=diff(t,1);
 
 alpha=1e-2;
 Param1=(1-alpha)*Param;
 Param2=(1+alpha)*Param;
 L=-logLike_lambda(t,M,Param,Fixed);
 
 for j=1:length(Param),
 % the first derivatives
 for i=1:length(Param),
     P1=Param;
     P1(i)=Param1(i);
     P2=Param;
     P2(i)=Param2(i);
     if (i~=j)
        P1(j)=Param2(j);
        P2(j)=Param2(j);
     
        L1=-logLike_lambda(t,M,P1,Fixed);
        L2=-logLike_lambda(t,M,P2,Fixed);
        dL_top(i)=(L2-L1)./(P2(i)-P1(i));
     
        P1(j)=Param1(j);
        P2(j)=Param1(j);
     
        L1=-logLike_lambda(t,M,P1,Fixed);
        L2=-logLike_lambda(t,M,P2,Fixed);
        dL_bottom(i)=(L2-L1)./(P2(i)-P1(i));
     
     
        J(i,j)=(dL_top(i)-dL_bottom(i))/(Param2(j)-Param1(j));
     else
       L1=-logLike_lambda(t,M,P1,Fixed);
       L2=-logLike_lambda(t,M,P2,Fixed);
       J(i,i)=(L2-2*L+L1)./(Param(i)-Param1(i)).^2;
     end
     
 end
 
 end
 
 E=sqrt(inv(J)); % Ide & Okutani except 1 sigma rule to be comparable to Ogata
 EE=diag(E)';
 
 
%   