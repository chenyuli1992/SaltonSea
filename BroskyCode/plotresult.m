% plot results
clear all
% load Results_hs1.5.mat
% load Results_mft_mc05_tw03.mat
% load Results_mft_mc0_tw03.mat
load Results_mft_new_mc15_tw05.mat
% load Results_mft_mc15.mat
% load Results_mft_mc15_tw1.mat
% load Results_brodsky2.mat
% load Results
t0=datenum('1-1-2008');
% N=49
% N=70
N=67
% N=61
for i=1:N
    mu_all(i)=Results(i).BestEst(3);
    tc(i)=(Results(i).t1+Results(i).t2)/2;
    tc(i)=(tc(i)-t0)/365+2008;
end

data2=load('../statistics/catalogs/sum1.5_production.dat');
L=size(data2,1);
for i=1:L
%   time2(i)=floor(data2(i,1)/100)+mod(data2(i,1),100)*0.0833;  
    year=floor(data2(i,1)/100);
    month=mod(data2(i,1),100);
    time2(i)=(datenum(year,month,1)-t0)/365+2008;
end
product=data2(:,3);
inject=data2(:,4);
sumprob=data2(:,5);
netprod=product-inject;

% correlation coefficient
y2 = interp1(time2,netprod,tc);
[R1,P1]=corrcoef(mu_all,y2)
y3 = interp1(time2,inject,tc);
[R2,P2]=corrcoef(mu_all,y3)
y4 = interp1(time2,product,tc);
[R3,P3]=corrcoef(mu_all,y4)
%% plot
close all
figure(1)
subplot 311
[AX,H1,H2]=plotyy(tc,mu_all,time2,netprod,'plot','plot');
%[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
ylim(AX(1),[0 max(mu_all)*1.05]);
% ylim(AX(1),[0.02 0.5]);
% ylim(AX(1),[0.02 0.14]);
ylim(AX(2),[1.0e6 3.5e6]);
xlim(AX(:),[2008 2014]);
text(0.01,0.85,'(a)','fontsize',14,'units','normalized');
ylabel(AX(1),'Seismicity Rate','fontsize',13);
ylabel(AX(2),'Net Production','fontsize',13);
subplot 312
[AX,H1,H2]=plotyy(tc,mu_all,time2,inject,'plot','plot');
%[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
ylim(AX(1),[0 max(mu_all)*1.05]);
ylim(AX(2),[4.5e6 9.5e6]);
xlim(AX(:),[2008 2014]);
text(0.01,0.85,'(b)','fontsize',14,'units','normalized');
ylabel(AX(1),'Seismicity Rate','fontsize',13);
ylabel(AX(2),'Injection Rate','fontsize',13);
subplot 313
[AX,H1,H2]=plotyy(tc,mu_all,time2,product,'plot','plot');
%[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
ylim(AX(1),[0 max(mu_all)*1.05]);
ylim(AX(2),[6.0e6 1.2e7]);
xlim(AX(:),[2008 2014]);
text(0.01,0.85,'(c)','fontsize',14,'units','normalized');
ylabel(AX(1),'Seismicity Rate','fontsize',13);
ylabel(AX(2),'Production Rate','fontsize',13);

figure(2)
% plot(mu_all,netprod(1:N))
scatter(mu_all,y2)
