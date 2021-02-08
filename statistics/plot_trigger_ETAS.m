% plot ETAS and cumulative for triggering 
clear all;

% all triggering events
% a1=[[2008,2,21,14,16,2.71];[2009,10,7,22,18,51];[2009,12,30,18,48,57.33];[2010,1,10,0,27,39.32];
%     [2010,4,4,22,40,42]; [2011,3,11,5,46,24.12]; [2012,8,27,4,37,19];[2013,2,6,1,12,27]];
% a1=['21-Feb-2008 14:16:02';'07-Oct-2009 22:18:51';'30-Dec-2009 18:48:57';'10-Jan-2010 00:27:39';
%     '04-Apr-2010 22:40:42'; '11-Mar-2011 05:46:24'; '27-Aug-2012 04:37:19'; '06-Feb-2013 01:12:27'];
% a1=['21-Feb-2008 14:16:02';'03-Aug-2009 17:59:56';'30-Dec-2009 18:48:57';'10-Jan-2010 00:27:39';
%      '27-Feb-2010 06:34:11';'04-Apr-2010 22:40:42'; '11-Mar-2011 05:46:24'; '06-Feb-2013 01:12:27'];
% after random beta 10000 times
a1=['03-Aug-2009 17:59:56';'30-Dec-2009 18:48:57';'04-Apr-2010 22:40:42';'19-Oct-2013 17:54:54'];
% atext1=['21-Feb-2008 M5.9';'03-Aug-2009 M6.9';'30-Dec-2009 M5.8';'10-Jan-2010 M6.5';
%     '27-Feb-2010 M8.8'; '04-Apr-2010 M7.2'; '11-Mar-2011 M9.1'; '06-Feb-2013 M8.0'];
atext1=['03-Aug-2009 M6.9';'30-Dec-2009 M5.8';'04-Apr-2010 M7.2'; '11-Mar-2011 M9.1'];
% atext2={'0.99kPa';'52.6kPa';'119kPa';'3.57kPa';'9.7kPa';'210kPa';'9.9kPa';'1.44kPa'}; 
atext2={'52.6kPa';'119kPa';'210kPa';'9.9kPa'}; 
% atext3={'500 km';'526.48 km';'88.51 km';'1157.60 km';'8867.08 km'; '103.18 km';'8732.53 km'; '9670.19 km'};
atext3={'526.48 km';'88.51 km';'103.18 km';'8732.53 km'; '8732.53 km'};
% PGV of 2012-08-27 need to be rechecked
t1=datenum(a1);
% t1=(t1-733408)/365+2008;
m1=[5.9, 6.9, 5.8, 6.5, 8.8, 7.2, 9.1, 8.0];

% load ETAS declustered catalog
a=load('catalogs/final_etas_time.dat_old');   %  ETAS not in middle
% a=load('catalogs/final_etas_new_2008_2013.dat');
M=a(:,3);
lat=a(:,2);
lon=a(:,1);
% location=a(:,13:14);
depth=-a(:,4);
t=datenum(a(:,7:12));
prob=a(:,5);
clear a;

% minLat = 33.1;
% maxLat = 33.25;
% minLon = -115.7;
% maxLon = -115.45;
minLat = 33.0;
maxLat = 33.3;
minLon = -115.7;
maxLon = -115.4;
maxDep = 10;
% mc = 0;
mc = -0.5;
LatLim = (lat > minLat & lat < maxLat);  
LonLim = (lon > minLon & lon < maxLon);
DepLim = (depth <= maxDep);
MLim = (M>mc);
SpaceLim=LatLim & LonLim & DepLim & MLim;
M=M(SpaceLim);
lat=lat(SpaceLim);
lon=lon(SpaceLim);
% location=location(SpaceLim,:);
depth=depth(SpaceLim);
t=t(SpaceLim);
prob=prob(SpaceLim);
% t=(t-datenum('2008-01-01'))/365+2008;

%% 
N=length(t1);
close all;
figure (1)
figurelabels=['(a)';'(b)';'(c)';'(d)'];
for i=1:4
    TimeLim=(t>t1(i)-30 & t<t1(i)+30);
    probselect=prob(TimeLim);
    tselect=t(TimeLim);
    tselect=tselect-t1(i);
    CDF1=cumsum(probselect);
    N1=length(probselect);
    CDF2=zeros(N1,1);
    % fit for background rate
    p=polyfit(tselect(tselect<0),CDF1(tselect<0),1);
    f = polyval(p,tselect);
    for j=1:N1
        CDF2(j)=j; 
    end
    subplot(2,2,i)
    colororder({'b','k'});
    yyaxis left
    p1=plot(tselect,CDF1,'LineWidth',1.5,'Color','b','DisplayName','S(t)'); hold on;
    p2=plot(tselect,f,'LineStyle','--','Color','b','DisplayName','Pre-mainshock'); hold on;
    plot([0 0],[0 1.1*CDF1(end)],'Color','r','LineStyle','--'); hold on;
    ylim([0 1.1*CDF1(end)]);
    ylabel('Background S(t)','FontSize',20);
    yyaxis right
    p3=plot(tselect,CDF2,'LineWidth',1.5,'Color','k','DisplayName','Before decluster'); hold on;
    ylabel('Number','FontSize',20);
    xlim([-30 30]);
    ylim([0 1.1*CDF2(end)]);
    legend([p1,p2,p3],'Location','SouthEast','FontSize',18);
    xlabel('Days to mainshock','FontSize',20);
    text(0.02,0.95,figurelabels(i,:),'Units','Normalized','FontSize',20);
    text(0.04,0.85,atext2(i),'Units','Normalized','FontSize',20);
    text(0.04,0.75,atext3(i),'Units','Normalized','FontSize',20);
    title(atext1(i,:),'FontSize',20);
    saveas(gcf,'etasallevents1.eps');
end
%%
% figure (2)
% figurelabels=['(e)';'(f)';'(g)';'(h)'];
% % for i=5:N
% for i=5:6
%     TimeLim=(t>t1(i)-30 & t<t1(i)+30);
%     probselect=prob(TimeLim);
%     tselect=t(TimeLim);
%     tselect=tselect-t1(i);
%     CDF1=cumsum(probselect);
%     N1=length(probselect);
%     CDF2=zeros(N1,1);
%     p=polyfit(tselect(tselect<0),CDF1(tselect<0),1);
%     f = polyval(p,tselect);
%     for j=1:N1
%         CDF2(j)=j; 
%     end
%     subplot(2,2,i-4)
%     colororder({'b','k'});
%     yyaxis left
%     p1=plot(tselect,CDF1,'LineWidth',1.5,'Color','b','DisplayName','S(t)'); hold on;
%     p2=plot(tselect,f,'LineStyle','--','Color','b','DisplayName','Pre-mainshock'); hold on;
%     plot([0 0],[0 1.1*CDF1(end)],'Color','r','LineStyle','--'); hold on;
%     ylim([0 1.1*CDF1(end)]);
%     ylabel('Background S(t)','FontSize',20);
%     yyaxis right
%     p3=plot(tselect,CDF2,'LineWidth',1.5,'Color','k','DisplayName','Before decluster'); hold on;
%     ylabel('Number','FontSize',20);
%     legend([p1,p2,p3],'Location','SouthEast','FontSize',18);
%     xlim([-30 30]);
%     ylim([0 1.1*CDF2(end)]);
%     xlabel('Days to mainshock','FontSize',20);
%     text(0.02,0.95,figurelabels(i-4,:),'Units','Normalized','FontSize',20);
%     text(0.04,0.85,atext2(i),'Units','Normalized','FontSize',20);
%     text(0.04,0.75,atext3(i),'Units','Normalized','FontSize',20);
%     title(atext1(i,:),'FontSize',20);
%     saveas(gcf,'etasallevents2.eps');
% end