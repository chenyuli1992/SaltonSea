clear;
try 
    matlabpool;
catch
end
 % READ in an ANSS catalog file in the format it is downloaded
 % from ANSS (uses ReadANSS.m in /home/brodsky/matlab/
 % [tread,Mread]=ReadANSS('./atsearch.25085'); 
%  [tread,Mread,lat,lon,depth]=Readhs('./hs_1981_2011_06_comb_K2_A.cat_so_SCSN_v01');
%  [tread2,Mread2,lat2,lon2,depth2]=ReadSCSN('./SCSN_all.txt');
%  Iadd=(tread2>max(tread));
%  tread=[tread' tread2(Iadd)'];
%  Mread=[Mread' Mread2(Iadd)'];
%  lat=[lat' lat2(Iadd)'];
%  lon=[lon' lon2(Iadd)'];
%  depth=[depth' depth2(Iadd)'];
 
 % read from my zmap file
 [tread,Mread,lat,lon,depth]=Readzmap('../statistics/catalogs/whole_2008_2013_new3_zmap_ss.dat');
% [tread,Mread,lat,lon,depth]=Readzmap('../statistics/catalogs/whole_2008_2013_new1_epoch.dat_sort');
% [tread,Mread,lat,lon,depth]=Readzmap('../statistics/salton_sea_2007_2013_zmap.dat');
 
 % limit to the SSGF
     % Limit lat/long to Llenos area 
     % Llenos lat/long
    minLat = 33.1;
    maxLat = 33.25;
    minLon = -115.7;
    maxLon = -115.45;
    maxDep = 15;

    LatLim = (lat > minLat & lat < maxLat);  
    LonLim = (lon > minLon & lon < maxLon);
    DepLim = (depth <= maxDep);
    SpaceLim=LatLim & LonLim & DepLim;
    
    tread=tread(SpaceLim);
    Mread=Mread(SpaceLim);
    
 
%%
 iyear=0;
 % numbr of years in each window
%  dwindow=0.2; 
%  dwindow=2; 
 dwindow=0.5;
%  dwindow=1;
%  dwindow=0.0833;
 yearmax=(max(tread)-datenum('1-1-2008'))/365-dwindow;
 
 for year=0:0.0833:yearmax,
 % for year=0:0.1:32,  
%[t,M]=ReadANSS('/home/brodsky/Geothermal/CheckETAS/RealData/catsearch.6981'); 

% If your file is not in ANSS format, just read in t,M however you like

% set start date (here picked to be after a data gap) and before recent
% swarm
iyear=iyear+1;
yearvect(iyear)=year; % set-up yearvect so that the rest is parallelizable
 end
 % preallocate;
Nyear=length(yearvect);

Results(Nyear).BestEst=[NaN NaN NaN];
Results(Nyear).EstErrorNum=[NaN NaN NaN];
Results(Nyear).t1=0;
Results(Nyear).t2=0;
Results(Nyear).t=0;
Results(Nyear).M=0;
Results(Nyear).Mmin=0;
Results(Nyear).L=0;

% options = optimset('Algorithm','interior-point');
options = optimoptions('fmincon','Algorithm','sqp')
%%
parfor iyear=1:Nyear,
    year=yearvect(iyear);
    iyear
    t1=datenum('1-1-2008')+year*365;
    t2=t1+365*dwindow;
    %datestr(t1)
    I=(tread>t1)&(tread<t2);
    t=tread(I);
    M=Mread(I);
%    Mmin=0.0;
%     Mmin=0.5;
%     Mmin=1.75;
    Mmin=1.50;

    % Find min magnitude of completeness using /home/brodsky/matlab/FindMth.m
    % You can also simply pick Mmin
    %[Mmin,bdum]=FindMth(M);
    %Mmin=Mmin+0.1;
    
        
    if (length(t)>2)
    t0=t(1);
    t=t-t0;

% limit the data to the magnitudes that are there
I=(M>Mmin);
Mnew=M(I)';
tnew=t(I)';

% initial guess vector for inversion
C0=0.005;
beta0=0.95;
mu0=2*length(t)./range(t);
Init=[C0 beta0 mu0];
CX0=0.006;
Fixed=[Mmin CX0];
% invert
% lower & upper bound of inversions
LB=[0  0. 0];
UB=[1 3 10];
if (length(tnew)>2)
    [P_out,fval] = fmincon(@(P)-logLike_lambda(tnew,Mnew,P,Fixed),Init,[],[],[],[],LB,UB,[],options);

% calculate likelihood for vector of beta values to show if the minimum is
% really well-behaved
% IF this is a good inversion, the minimum should not be at the edges
% b_vect=[0:0.05:2];
% for i=1:length(b_vect),
%     L(i)=-logLike_lambda(t,M,[P_out(1:1) b_vect(i) P_out(3)],Fixed);
% end

% Calculate 1 sigma errors based on numerically estimating the second
% derviatives
EstErrorNum=errorMLE_numeric(tnew,Mnew,P_out,Fixed);
%BestEst=P_out;

else
     P_out=[NaN NaN NaN];
    EstErrorNum=[NaN NaN NaN];
end
    else
        P_out=[NaN NaN NaN];
        EstErrorNum=[NaN NaN NaN];
     end
    
% % output results
% LB 
% UB % important! check that the bestest does not hit the lower or upper bound of the inversion
% if so, extend inversion bounds and do over
% BestEst
% EstErrorNum

Results(iyear).BestEst=P_out;
Results(iyear).EstErrorNum=EstErrorNum;
Results(iyear).t1=t1;
Results(iyear).t2=t2;
Results(iyear).t=tnew;
Results(iyear).M=Mnew;
Results(iyear).Mmin=Mmin;

%Results(iyear).L=L;

% % show original catalog
% figure(1)
% plot(t+t1,M,'.');
% datetick;
% 
% % show beta minimum
% figure(2)
% plot(b_vect,L);
% hold on;
% plot(P_out(3),fval,'r*');
% hold off;
% title(datestr(t1))
% 
% figure(3)
% % check rate calculation after inversion
% % R=1./diff(t,1);
% % T=(t(1:end-1)+t(2:end))/2;
% % 
%  lambda=CalcLambda(t,M,P_out,Fixed);
%  tau=cumtrapz(t,lambda);% transformed time = predicted # of shocks
%  N=length(tau);
% % semilogy(T+t0,R,t+t0,lambda);
% % datetick;
% % compare predicted cumulative number with actual
% %plot([1:length(t)],cumsum(lambda.*[0 diff(t,1)]),[0 3000],[0 3000])
% % the second curve is the 1-1 line and a perfect fit should match this.
% plot([1:N],tau,tau,tau);
% 
% % attempt to do confidence bounds (I don't think this is quite right)
% % c=[];
% % for i=1:length(tau),
% % [h,p,k,c(i)]=kstest(tau(1:i),[[0:N]' [0:1/N:1]'],0.01);
% % end
% c=0.2;
% hold on;
% plot(tau,tau.*(1+c),'b--',tau,tau.*(1-c),'b--')
% hold off;
% 
% xlabel('Predicted Cumulative Number of Events')
% ylabel('Actual Cumulative Number of Events')
% title(datestr(t1))
% 
% figure(4)
% A=[Results.BestEst];
% mu=A(3:3:end);
% 
% plot(([Results.t1]+[Results.t2])/2,mu*1e9,'r*')
% 
% 
% 
% datetick;
% 

end
save Results;

% figure(4)
% 
% PI=load('SaltonS.prn');
% tPI=(datenum(PI(:,1),PI(:,2),15));
% Net=PI(:,3)-PI(:,4);
% hold on;
% plot(tPI,cumsum(Net));
% hold off;
