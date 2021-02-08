% compute the cumulative background number monthly
clear all;
clc;
% load ETAS declustered catalog
% a=load('catalogs/final_etas_time.dat_old');   %  ETAS not in middle
a=load('catalogs/final_etas_new_2008_2013.dat');
M=a(:,3);
lat=a(:,2);
lon=a(:,1);
% location=a(:,13:14);
depth=-a(:,4);
% t=datenum(a(:,7:12));
year=a(:,7);
month=a(:,8);
prob=a(:,5);
clear a;
minLat = 33.0;
maxLat = 33.3;
minLon = -115.7;
maxLon = -115.4;
maxDep = 10;
% mc = 0;
% mc = -0.5;
mc=1.75;
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
% t=t(SpaceLim);
year=year(SpaceLim);
month=month(SpaceLim);
prob=prob(SpaceLim);


%% read production
a=load('catalogs/sum0_production.dat');
product=a(:,3);
inject=a(:,4);
clear a;
net=product-inject;
%%
rate=zeros(72,1);
k=1
for i=2008:2013
    for j=1:12
        monthLim=(year==i & month==j);
        probselect=prob(monthLim);
        rate(k)=sum(probselect);
        k=k+1;
    end
end

%% correlation
[R1,p1]=corrcoef(rate(1:70),net);
[R2,p2]=corrcoef(rate(1:70),inject);
[R3,p3]=corrcoef(rate(1:70),product);

% for mc=-0.5, p>0.05 for all cases, no correlation

%% plot
figure (3)
t1=1:72; t1=t1/12;
t2=t1(1:70);
[AX,H1,H2]=plotyy(t1,rate,t2,net,'plot','plot');