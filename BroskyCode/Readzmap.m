function [t,M,lat,lon,depth]= Readzmap(F)

    id=fopen(F);
    A=textscan(id,'%f %f %f %f %f %f %f %f %f %f %f %*[^\n]','headerlines',0);
    fclose(id);
    
    lat=A{2};
    lon=A{1};
    depth=A{7};
    
    M=A{6};
    
    t=datenum(A{3:5}, A{8:10});
%     t2=datenum(A{4:6});
%     t0=datenum('00:00:00');
%     t=t1+t2-t0;
    
    
    
    