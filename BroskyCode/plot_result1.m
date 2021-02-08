clear all;

data2=load('../statistics/sum1.5_production_new.dat');
L=size(data2,1);
t0=datenum('1-1-2008');
for i=1:L
%   time2(i)=floor(data2(i,1)/100)+mod(data2(i,1),100)*0.0833;  
    year=floor(data2(i,1)/100);
    month=mod(data2(i,1),100);
    time2(i)=(datenum(year,month,1)-t0)/365+2008;
end
product=data2(:,3);
inject=data2(:,4);
% sum of Mc=0 and Mc=1.5
sumprob1=data2(:,5);  %Mc=0;
sumprob2=data2(:,6);  %Mc=1.5
netprod=product-inject;

% [R1,P1]=corrcoef(sumprob1,netprod)
% [R2,P2]=corrcoef(sumprob1,inject)
% [R3,P3]=corrcoef(sumprob1,product)

%% plot in 6 channels
close all
figure(2)
subplot 321
yyaxis left;
plot(time2,sumprob1);
ylim([0 max(sumprob1)*1.05]);
ylabel('Seismicity Rate','fontsize',13);
yyaxis right;
plot(time2,netprod);
ylim([1.0e6 3.5e6]);
xlim([2008 2014]);
text(0.01,0.9,'(a)','fontsize',14,'units','normalized');

subplot 323
yyaxis left;
plot(time2,sumprob1);
ylim([0 max(sumprob1)*1.05]);
ylabel('Seismicity Rate','fontsize',13);
yyaxis right;
plot(time2,inject);
ylim([4.5e6 9.5e6]);
xlim([2008 2014]);
text(0.01,0.9,'(b)','fontsize',14,'units','normalized');

subplot 325
yyaxis left;
plot(time2,sumprob1);
ylim([0 max(sumprob1)*1.05]);
ylabel('Seismicity Rate','fontsize',13);
yyaxis right;
plot(time2,product);
ylim([6.0e6 1.2e7]);
xlim([2008 2014]);
% [AX,H1,H2]=plotyy(time2,sumprob1,time2,product,'plot','plot');
text(0.01,0.9,'(c)','fontsize',14,'units','normalized');

subplot 322
yyaxis left;
plot(time2,sumprob2);
ylim([0 max(sumprob2)*1.05]);
yyaxis right;
plot(time2,netprod);
ylim([1.0e6 3.5e6]);
xlim([2008 2014]);
ylabel('Net Production','fontsize',13);
text(0.01,0.9,'(d)','fontsize',14,'units','normalized');
% [AX,H1,H2]=plotyy(time2,sumprob2,time2,netprod,'plot','plot');
% ylabel(AX(1),'Seismicity Rate','fontsize',13);

subplot 324
yyaxis left;
plot(time2,sumprob2);
ylim([0 max(sumprob2)*1.05]);
yyaxis right;
plot(time2,inject);
ylim([4.5e6 9.5e6]);
xlim([2008 2014]);
ylabel('Injection Rate','fontsize',13);
text(0.01,0.9,'(e)','fontsize',14,'units','normalized');
% [AX,H1,H2]=plotyy(time2,sumprob2,time2,inject,'plot','plot');

subplot 326
yyaxis left;
plot(time2,sumprob2);
ylim([0 max(sumprob2)*1.05]);
yyaxis right;
plot(time2,product);
ylim([6.0e6 1.2e7]);
xlim([2008 2014]);
ylabel('Production Rate','fontsize',13);
text(0.01,0.9,'(f)','fontsize',14,'units','normalized');
% [AX,H1,H2]=plotyy(time2,sumprob2,time2,product,'plot','plot');
% ylabel(AX(1),'Seismicity Rate','fontsize',13);


%% plot in 3 channels
% close all
% figure(1)
% subplot 311
% [AX,H1,H2]=plotyy(time2,sumprob,time2,netprod,'plot','plot');
% %[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
% ylim(AX(1),[0 max(sumprob)*1.05]);
% ylim(AX(2),[1.0e6 3.5e6]);
% xlim(AX(:),[2008 2014]);
% text(0.01,0.85,'(a)','fontsize',14,'units','normalized');
% ylabel(AX(1),'Seismicity Rate','fontsize',13);
% ylabel(AX(2),'Net Production','fontsize',13);
% subplot 312
% [AX,H1,H2]=plotyy(time2,sumprob,time2,inject,'plot','plot');
% %[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
% ylim(AX(1),[0 max(sumprob)*1.05]);
% ylim(AX(2),[4.5e6 9.5e6]);
% xlim(AX(:),[2008 2014]);
% text(0.01,0.85,'(b)','fontsize',14,'units','normalized');
% ylabel(AX(1),'Seismicity Rate','fontsize',13);
% ylabel(AX(2),'Injection Rate','fontsize',13);
% subplot 313
% [AX,H1,H2]=plotyy(time2,sumprob,time2,product,'plot','plot');
% %[AX,H1,H2]=plotyy(1:N,mu_all(1:N),1:N,netprod(1:N),'plot','plot');
% ylim(AX(1),[0 max(sumprob)*1.05]);
% ylim(AX(2),[6.0e6 1.2e7]);
% xlim(AX(:),[2008 2014]);
% text(0.01,0.85,'(c)','fontsize',14,'units','normalized');
% ylabel(AX(1),'Seismicity Rate','fontsize',13);
% ylabel(AX(2),'Production Rate','fontsize',13);
