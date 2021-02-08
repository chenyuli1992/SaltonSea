% plot triggering events
clear all;

% 1 day beta > 2
a1=[[2008,2,21,14,16,2.71];[2009,12,30,18,48,57.33];[2010,1,10,0,27,39.32];
    [2010,4,4,22,40,42]; [2011,3,11,5,46,24.12]; [2013,2,6,1,12,27]];
t11=datenum(a1);
t11=(t11-733408)/365+2008;
m11=[5.9, 5.8, 6.5, 7.2, 9.1, 8.0];
% 1 day empirical triggered
a2=['07-Oct-2009 22:18:51';'10-Jan-2010 00:27:39'; '04-Apr-2010 22:40:42'; '27-Aug-2012 04:37:19';
    '06-Feb-2013 01:12:27'];
t12=datenum(a2);
t12=(t12-733408)/365+2008;
m12=[7.8, 6.5, 7.2, 7.4, 8.0];

% 30 day beta >2
b1=[[2009,12,30,18,48,57.33];[2010,1,10,0,27,39.32];
    [2010,4,4,22,40,42]; [2011,3,11,5,46,24.12]; [2013,2,6,1,12,27]];
t21=datenum(b1);
t21=(t21-733408)/365+2008;
m21=[5.8, 6.5, 7.2, 9.1, 8.0];
% 30 day empirical
b2=['30-Dec-2009 18:48:57';'10-Jan-2010 00:27:39'; '04-Apr-2010 22:40:42'];
t22=datenum(b2);
t22=(t22-733408)/365+2008;
m22=[5.8, 6.5, 7.2];

figure(1)
subplot 121
scatter(t11,m11,100,'k','o');
hold on;
scatter(t12,m12,100,'k','+');
box on;
xlim([2008 2014]);
ylim([5.5 9.5]);
xlabel('Time','FontSize',14);
ylabel('Magnitude','FontSize',14);
text(2008.1,9.2,'(a) 1-day','FontSize',14);
axis square

subplot 122
scatter(t21,m21,100,'k','o');
hold on;
scatter(t22,m22,100,'k','+');
box on;
xlim([2008 2014]);
ylim([5.5 9.5]);
xlabel('Time','FontSize',14);
ylabel('Magnitude','FontSize',14);
text(2008.1,9.2,'(b) 30-day','FontSize',14);
axis square